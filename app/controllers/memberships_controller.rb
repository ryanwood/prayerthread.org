class MembershipsController < ApplicationController
  before_filter :authenticate
  
  def destroy
    @membership = Membership.find(params[:id])
    @group = @membership.group
    if can_delete?( @membership )
      @membership.destroy
      flash[:notice] = "Successfully unsubscribed from group."
    end
    redirect_to group_url(@group)
  end
  
  private
  
  def can_delete?(membership)
    @membership && ( current_user == membership.user || current_user == membership.group.owner )
  end
end
