class PrayersController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource
  after_filter :send_notifications, :only => :create
  
  def index
    set_view
    if params[:print]
      @prayers = Prayer.find_view(@view, current_user).paginate( :page => 1, :per_page => 50 )
    else
      @prayers = Prayer.find_view(@view, current_user).paginate( :page => params[:page] )
    end
    
    @intercessions = current_user.intercessions.today.map { |i| i.prayer.id }
    render :layout => (params[:print] ? 'print' : 'application')
  end
  
  def show
    @recent_comments = @prayer.audience_comments.recent
    @updates = @prayer.updates
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
    
    def set_view
      view = (params[:view] || cookies[:view] || 'all').to_sym
      detail = (params[:details] || cookies[:detail] || 0).to_i
      length = { :expires => 6.months.from_now }
      cookies[:view] = length.merge( :value => view )
      cookies[:detail] = length.merge( :value => detail )
      
      @view = view
      @detail = detail
    end
end
