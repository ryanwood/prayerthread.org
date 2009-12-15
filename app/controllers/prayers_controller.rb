class PrayersController < ApplicationController
  before_filter :login_required
  
  def index
    @prayers = Prayer.all
  end
  
  def show
    @prayer = Prayer.find(params[:id])
  end
  
  def new
    @prayer = Prayer.new
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
    @prayer = Prayer.find(params[:id])
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
    @prayer = Prayer.find(params[:id])
    @prayer.destroy
    flash[:notice] = "Successfully destroyed prayer."
    redirect_to prayers_url
  end
end
