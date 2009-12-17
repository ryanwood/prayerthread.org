class AccountsController < ApplicationController
  before_filter :login_required

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated account."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    current_user.destroy
    flash[:notice] = "Successfully deleted your account."
    redirect_to logout
  end
end
