class CommentsController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :nested => :prayer
  before_filter :check_group_access, :only => :create
  after_filter :send_notifications, :only => :create
  
  def index
    @comments = @prayer.comments
  end
  
  def new
  end
  
  def create
    @comment.prayer = @prayer
    @comment.user = current_user
    msg = ''
    if params[:comment] && params[:comment].has_key?(:prayer)
      @comment.prayer.answered = params[:comment][:prayer][:answered]
      msg = " and marked the prayer answered"
    end
    if @comment.save
      flash[:notice] = "Successfully created comment#{msg}."
      redirect_to @prayer
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @prayer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to prayer_comments_url(@prayer)
  end
  
  protected
    
    def check_group_access
      allowed_groups = @prayer.groups
      current_user.groups.each { |g| return true if allowed_groups.include?(g) }
      unauthorized!
    end
    
    def send_notifications
      Notification.process( :created, @comment )
    end
  
end
