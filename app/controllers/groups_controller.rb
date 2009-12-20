class GroupsController < ApplicationController
  before_filter :authenticate
  
  def index
    @groups = current_user.groups
  end
  
  def show
    @group = current_user.groups.find(params[:id])
    @prayers = @group.prayers( :limit => 5 )
    @memberships = @group.memberships
    @invitations = @group.invitations.pending
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group])
    @group.owner = current_user
    if @group.save
      flash[:notice] = "Successfully created group."
      redirect_to @group
    else
      render :action => 'new'
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = current_user.groups.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:notice] = "Successfully updated group."
      redirect_to @group
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    flash[:notice] = "Successfully destroyed group."
    redirect_to groups_url
  end
  
end
