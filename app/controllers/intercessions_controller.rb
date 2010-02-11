class IntercessionsController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :nested => :prayer
  
  def index
    @intercessions = Intercession.find_all_grouped(current_user)
    @intercessions_exist = @intercessions.find { |k, v| !v.empty? }
  end
  
  def new
    create
  end
  
  def create
    unless current_user.intercessions.today.regarding(@prayer).exists?
      @prayer.intercessions.create( :user => current_user )
    end
    respond_to do |format|
      format.html { 
        flash[:notice] = "Thanks for praying."
        redirect_to prayers_path 
      }
      format.js { render :text => "Thanks for praying!" }
    end
  end
  
end
