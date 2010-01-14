class UsersController < Clearance::UsersController
  
  def show
    @user = current_user
    render :action => "edit"
  end
  
  def edit
    @user = current_user
  end

  def update
    # render :inline => "<%= debug params %>" and return
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated account."
      redirect_to account_path
    else
      render :action => 'edit'
    end
  end

  # Clearance Overrides
  
  def new
    @user = User.new(params[:user])
    cookies[:invitation_token] = { :value => params[:token], :expires => 1.year.from_now } if params[:token]
    token = cookies[:invitation_token]
    if @invitation = Invitation.find_by_token(token)
      @user.email = @invitation.recipient_email
      @user.invitation_token = @invitation.token
    end
    render :template => 'users/new'
  end

  def create
    @user = User.new params[:user]
    @invitation = Invitation.find_by_token(params[:user][:invitation_token]) if params[:user][:invitation_token]
    if @user.save
      flash_notice_after_create
      redirect_to(url_after_create)
    else
      render :template => 'users/new'
    end
  end
  
end
