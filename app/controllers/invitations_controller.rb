class InvitationsController < ApplicationController
  before_filter :authenticate, :except => :confirm
  before_filter :load_group, :only => [:new, :create]
  before_filter :forbid_missing_token, :only => [:confirm]
  
  def index
    @invitations = current_user.invitations.pending_and_ignored
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
    @invitation = Invitation.find(params[:id])
    if can? :destroy, @invitation
      @invitation.destroy
      flash[:notice] = "Successfully deleted invitation."
    else
      flash[:error] = "Sorry, only the group owner or recipient can delete an invitation"
    end
    redirect_to invitations_path
  end
  
  def confirm
    @invitation = Invitation.pending.find_by_token(params[:token])
    if @invitation
      @user = current_user || User.find_by_email(@invitation.recipient_email)
      if @user
        @user.invitations << @invitation
        @user.save!
        flash[:notice] = "Please sign in to accept your invitation." if signed_out?
        redirect_to invitations_path
      else
        redirect_to sign_up_path( :token => params[:token] )
      end
    else
      flash[:error] = "Unable to find a valid invitation."
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
  
  def ignore
    if @invitation = current_user.invitations.find(params[:id])
      @invitation.update_attribute :ignored, true
      flash[:notice] = "That invitation won't bother you anymore."
    else
      flash[:error] = "Unable to find a matching invitation"
    end
    redirect_to invitations_path
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
