class PrayersController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource
  
  def index
    set_view
    page_params = params[:print] ? { :page => 1, :per_page => 50 } : { :page => params[:page] }
    @prayers = Prayer.view(@view).for_user(current_user).paginate(page_params)
    
    @intercessions = current_user.intercessions.today.map { |i| i.prayer.id }
    render :layout => (params[:print] ? 'print' : 'application')
  end
  
  def show
    @comments = @prayer.comments
    @comment = @prayer.comments.new( :intercede => 1 )
  end
  
  def new
    @groups = current_user.groups
  end
  
  def create
    @prayer.user = current_user
    if @prayer.save
      flash[:notice] = "Successfully created prayer."
      redirect_to @prayer
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def answer
  end
  
  def update
    if @prayer.update_attributes(params[:prayer])
      flash[:notice] = "Successfully updated prayer."
      redirect_to @prayer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @prayer.destroy
    flash[:notice] = "Successfully deleted prayer."
    redirect_to prayers_url
  end

end
