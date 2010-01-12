class MembershipsController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :nested => :group, :except => :create
  
  def index
    load_memberships_and_invites
    @invitation = Invitation.new
  end
  
  def create
    @group = Group.find(params[:group_id])
    # This creates an invitation for a membership, not the membership directly
    @invitation = @group.invitations.build(params[:invitation])
    @invitation.sender = current_user
    if @invitation.save
      flash[:notice] = "Successfully sent invitation for #{@invitation.recipient_email}."
      redirect_to group_memberships_path(@group)
    else
      load_memberships_and_invites
      render :action => 'index'
    end
  end
  
  def destroy
    user = @membership.user
    @membership.destroy
    flash[:notice] = "Successfully removed #{user.name} from #{@group.name}."
    redirect_to group_memberships_url(@group)
  end
  
  protected
  
    def load_memberships_and_invites
      @memberships = @group.memberships
      @invitations = @group.invitations.pending
    end

end
