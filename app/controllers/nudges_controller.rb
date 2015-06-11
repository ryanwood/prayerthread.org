class NudgesController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource :prayer
  load_and_authorize_resource :nudge, :through => :prayer

  def new
    create
  end

  def create
    nudge = @prayer.nudges.build( :user => current_user )
    if nudge.save
      msg = "We've nudged #{nudge.prayer.user.first_name} for you."
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
