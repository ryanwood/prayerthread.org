class InvitationsController < ApplicationController
  before_filter :authenticate, :except => :confirm
  before_filter :load_group, :only => [:new, :create, :destroy]
  before_filter :forbid_missing_token, :only => [:confirm]
  
  def confirm
    @invitation = Invitation.find_by_token(params[:token])
    @user = User.find_by_email(@invitation.recipient_email)
    if @user
      # known user, just send them home and they'll see the invite there
      redirect_to root_url
    else
      # unknown user, let's send them to sign up with the token
      redirect_to sign_up_path( :token => params[:token] )
    end
  end
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.group = @group
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
    @invitation.destroy
    flash[:notice] = "Successfully destroyed invitation."
    redirect_to group_url(@group)
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
