class PrayersController < ApplicationController
  before_filter :authenticate
  
  def index
    @prayers = Prayer.all_for(current_user)
  end
  
  def show
    @prayer = Prayer.find_for(params[:id], current_user)
    raise ActiveRecord::RecordNotFound, "Record not found" unless @prayer
    @recent_comments = @prayer.comments.recent
  end
  
  def new
    @prayer = Prayer.new
    @groups = current_user.groups
  end
  
  def create
    @prayer = Prayer.new(params[:prayer])
    @prayer.user = current_user
    if @prayer.save
      flash[:notice] = "Successfully created prayer."
      redirect_to @prayer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @prayer = current_user.prayers.find(params[:id])
  end
  
  def update
    @prayer = Prayer.find(params[:id])
    if @prayer.update_attributes(params[:prayer])
      flash[:notice] = "Successfully updated prayer."
      redirect_to @prayer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @prayer = current_user.prayers.find(params[:id])
    @prayer.destroy
    flash[:notice] = "Successfully destroyed prayer."
    redirect_to prayers_url
  end
end
