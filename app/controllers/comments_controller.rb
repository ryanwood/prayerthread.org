class CommentsController < ApplicationController
  before_filter :authenticate
  before_filter :load_prayer
  
  def index
    @comments = @prayer.comments
  end
  
  def new
    @comment = @prayer.comments.build
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.prayer = @prayer
    @comment.user = current_user
    msg = ''
    if params[:comment] && params[:comment].has_key?(:prayer)
      @comment.prayer.answered = params[:comment][:prayer][:answered]
      msg = " and marked the prayer answered"
    end
    if @comment.save
      flash[:notice] = "Successfully created comment#{msg}."
      redirect_to @prayer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @comment = current_user.comments.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @prayer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to prayer_comments_url(@prayer)
  end
  
  private
  
    def load_prayer
      @prayer = Prayer.find(params[:prayer_id]) if params[:prayer_id]
    end
  
end
