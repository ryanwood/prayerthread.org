class PrayersController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource
  after_filter :send_notifications, :only => :create
  
  def index
    @view = (params[:view] || session[:view] || 'all').to_sym
    session[:view] = @view
    @prayers = Prayer.find_view(@view, current_user).paginate( :page => params[:page] )
    @intercessions = current_user.intercessions.today.map { |i| i.prayer.id }
  end
  
  def show
    @recent_comments = @prayer.comments.recent
    @has_intercession = current_user.intercessions.today.regarding(@prayer).exists?
  end
  
  def new
    @groups = current_user.groups
  end
  
  def create
    @prayer.user = current_user
    if @prayer.save
      flash[:notice] = "Successfully created prayer."
      redirect_to @prayer
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def answer
  end
  
  def update
    previously_answered = @prayer.answered?
    if @prayer.update_attributes(params[:prayer])
      Notification.fire(:answered, @prayer) if !previously_answered && @prayer.answered?
      flash[:notice] = "Successfully updated prayer."
      redirect_to @prayer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @prayer.destroy
    flash[:notice] = "Successfully destroyed prayer."
    redirect_to prayers_url
  end
  
  protected
  
    def send_notifications
      Notification.fire(:created, @prayer)
    end
end
