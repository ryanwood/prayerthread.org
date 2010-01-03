class PrayersController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource
  
  def index
    @prayers = Prayer.all_for(current_user)
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
  
  def update
    if @prayer.update_attributes(params[:prayer])
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
end
