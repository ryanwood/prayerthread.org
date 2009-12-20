class InvitationsController < ApplicationController
  before_filter :authenticate, :except => :confirm
  before_filter :load_group, :only => [:new, :create, :destroy]
  before_filter :forbid_missing_token, :only => [:confirm]
  
  def index
    @invitations = current_user.pending_invitations
  end
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = @group.invitations.build(params[:invitation])
    @invitation.sender = current_user
    if @invitation.save
      flash[:notice] = "Successfully sent invitation for #{@invitation.recipient_email}."
      redirect_to @group
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @invitation = @group.invitations.find(params[:id])
    if @invitation && current_user == @group.owner
      @invitation.destroy
      flash[:notice] = "Successfully cancelled invitation."
    else
      flash[:error] = "Only the group owner can cancel an invitation"
    end
    redirect_to group_url(@group)
  end
  
  def confirm
    @invitation = Invitation.pending.find_by_token(params[:token])
    if @invitation
      @user = User.find_by_email(@invitation.recipient_email)
      if @user
        flash[:notice] = "Please sign in to accept your invitation" if signed_out?
        # known user, just send them home and they'll see the invite there
        redirect_to accept_invitation_path(@invitation, :token => params[:token])
      else
        # unknown user, let's send them to sign up with the token
        redirect_to sign_up_path( :token => params[:token] )
      end
    else
      redirect_to root_path
    end
  end
  
  def accept
    @invitation = Invitation.pending.find_by_id_and_token(params[:id], params[:token])
    if @invitation
      @invitation.accept!(current_user)
      flash[:notice] = "You have successfully joined the '#{@invitation.group.name}' group."
      redirect_to @invitation.group
    else
      flash[:error] = "Unable to find a matching invitation"
      redirect_to root_path
    end
  end
  
  private
  
  def load_group
    @group = Group.find(params[:group_id])
  end
  
  def forbid_missing_token
    if params[:token].blank?
      raise ActionController::Forbidden, "missing token"
    end
  end
end
