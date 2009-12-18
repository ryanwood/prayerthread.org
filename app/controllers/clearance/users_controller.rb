class Clearance::UsersController < ApplicationController
  unloadable

  before_filter :redirect_to_root, :only => [:new, :create], :if => :signed_in?
  filter_parameter_logging :password

  def new
    @user = ::User.new(params[:user])
    @invitation = Invitation.find_by_token(params[:token]) if params[:token]
    if @invitation
      @user.email = @invitation.recipient_email
      @user.invitation_id = @invitation.id
    end
    render :template => 'users/new'
  end

  def create
    @user = ::User.new params[:user]
    if @user.save
      flash_notice_after_create
      redirect_to(url_after_create)
    else
      render :template => 'users/new'
    end
  end

  private

  def flash_notice_after_create
    flash[:notice] = translate(:deliver_confirmation,
      :scope   => [:clearance, :controllers, :users],
      :default => "You will receive an email within the next few minutes. " <<
                  "It contains instructions for confirming your account.")
  end

  def url_after_create
    new_session_url
  end
end
