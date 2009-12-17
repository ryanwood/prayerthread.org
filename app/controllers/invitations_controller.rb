class InvitationsController < ApplicationController
  before_filter :load_group
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.group = @group
    @invitation.sender = current_user
    if @invitation.save
      flash[:notice] = "Successfully created invitation."
      redirect_to @group
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    flash[:notice] = "Successfully destroyed invitation."
    redirect_to invitations_url
  end
  
  private
  
  def load_group
    @group = Group.find(params[:group_id])
  end
end
