class NudgesController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :nested => :prayer

  def new
    create
  end

  def create
    nudge = @prayer.nudges.build( :user => current_user )
    if nudge.save
      msg = "We've nudging #{nudge.prayer.user.first_name}."
    else
      msg = "Sorry, we had a problem nudging."
    end
    respond_to do |format|
      format.html { 
        flash[:notice] = msg
        redirect_to prayers_path 
      }
      format.js { render :text => msg }
    end
  end
end
