class GroupsController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :group
  
  def show
    set_view
    page_params = params[:print] ? { :page => 1, :per_page => 50 } : { :page => params[:page] }
    @prayers = @group.prayers.view(@view).for_user(current_user).paginate(page_params)
    
    @intercessions = current_user.intercessions.today.map { |i| i.prayer.id }
    render :layout => (params[:print] ? 'print' : 'application')
    
  end
  
  def new
  end
  
  def create
    @group.owner = current_user
    if @group.save
      flash[:notice] = "Successfully created group."
      redirect_to group_memberships_path(@group)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    if @group.update_attributes(params[:group])
      flash[:notice] = "Successfully updated group."
      redirect_to @group
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @group.destroy
    flash[:notice] = "Successfully destroyed group."
    redirect_to groups_url
  end
  
end
