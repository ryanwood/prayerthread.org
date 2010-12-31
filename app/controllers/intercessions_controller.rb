class IntercessionsController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :prayer
  load_and_authorize_resource :intercession, :through => :prayer
  
  def new
    create
  end
  
  def create
    intercession = @prayer.intercessions.build( :user => current_user )
    if intercession.save
      msg = "Thanks for praying."
    else
      msg = "Sorry, there was a problem."
    end
    respond_to do |format|
      format.js { render :text => msg }
      format.all { 
        flash[:notice] = msg
        redirect_to @prayer
      }
    end
  end
end
