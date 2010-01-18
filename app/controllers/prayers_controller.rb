class PrayersController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource
  
  def index
    @prayers = Prayer.paginate :all,
      :page => params[:page],
      :select => "DISTINCT prayers.*",
      :include => :groups, 
      :conditions => ['groups.id IN (?) OR prayers.user_id = ?', current_user.groups.map {|g| g.id }, current_user.id],
      :order => 'prayers.thread_updated_at DESC'
  end
  
  def show
    @recent_comments = @prayer.comments.recent
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
    if @prayer.update_attributes(params[:prayer])
      flash[:notice] = "Successfully #{params[:prayer][:answer] ? "answered" : "updated"} prayer."
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
end
