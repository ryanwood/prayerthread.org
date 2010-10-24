class CommentsController < ApplicationController
  before_filter :authenticate
  
  load_and_authorize_resource :prayer
  load_resource :comment, :through => :prayer
  authorize_resource :comment, :through => :prayer, :except => [:new, :create]
  
  after_filter :send_notifications, :only => :create
  
  def index
    # @comments = @prayer.comments
    redirect_to prayer_path(@prayer, :anchor => 'comments')
  end
  
  def new
    authorize! :new, @prayer => Comment
    redirect_to prayer_path(@prayer, :anchor => 'new_comment')
  end
  
  def create
    authorize! :new, @prayer => Comment
    @comment.user = current_user
    msg = ''
    if params[:comment] && params[:comment].has_key?(:prayer)
      @comment.prayer.answered = params[:comment][:prayer][:answered]
      msg = " and marked the prayer answered"
    end
    if @comment.save
      redirect_to @prayer, :notice => "Successfully created comment#{msg}."
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
    redirect_to prayer_path(@prayer), :notice => "Successfully deleted comment."
  end
  
  protected
    
    def send_notifications
      Notification.fire( :created, @comment )
    end
  
end
