class CommentsController < ApplicationController
  before_filter :authenticate
  before_filter :load_prayer
  
  def index
    @comments = @prayer.comments
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = @prayer.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to @prayer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
    raise ActionController::Forbidden unless current_user == @comment.user
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_url
  end
  
  private
  
    def load_prayer
      @prayer = Prayer.find(params[:prayer_id]) if params[:prayer_id]
    end
  
end
