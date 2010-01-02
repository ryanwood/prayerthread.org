class MembershipsController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource
  
  def destroy
    @group = @membership.group
    @membership.destroy
    flash[:notice] = "Successfully deleted group membership in #{@group.name}."
    redirect_to group_url(@group)
  end
end
