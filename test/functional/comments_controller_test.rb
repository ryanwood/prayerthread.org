require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  def setup
    @comment = Factory(:comment)
    @prayer = @comment.prayer
    @user = @comment.user
    sign_in_as @user
  end
  
  context "on GET to :index" do
    setup { get :index, :prayer_id => @prayer }
    should_assign_to :comments
    should_assign_to( :prayer ) { @prayer }
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
  
  context "on GET to :new" do
    setup { get :new, :prayer_id => @prayer }
    should_assign_to :comment
    should_assign_to( :prayer ) { @prayer }
    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash
  end
  
  context "on GET to :edit" do
    context "with a comment you own" do
      setup { get :edit, :id => @comment, :prayer_id => @prayer }
      should_assign_to :comment
      should_assign_to( :prayer ) { @prayer }
      should_respond_with :success
      should_render_template :edit
      should_not_set_the_flash
    end
    
    context "with a comment you don't own" do
      setup do
        sign_in_as Factory(:email_confirmed_user)
      end
      should "raise a Record Not Found error" do
        assert_raise( ActiveRecord::RecordNotFound ) {
          get :edit, :id => @comment, :prayer_id => @prayer
        }
      end
    end
  end
  
  context "on DELETE to :destroy" do
    context "with a comment you own" do
      setup { delete :destroy, :id => @comment, :prayer_id => @prayer }
      should_assign_to :comment
      should_assign_to( :prayer ) { @prayer }
      should_respond_with :redirect
      should_redirect_to("the comment list for the current prayer") { prayer_comments_url(@prayer) }
      should_set_the_flash_to /Success/
    end
    
    context "with a comment you don't own" do
      setup do
        sign_in_as Factory(:email_confirmed_user)
      end
      should "raise a Record Not Found error" do
        assert_raise( ActiveRecord::RecordNotFound ) {
          delete :destroy, :id => @comment, :prayer_id => @prayer
        }
      end
    end
  end
  
  context "on POST to :create" do
    should "render new template when model is invalid" do
      Comment.any_instance.stubs(:valid?).returns(false)
      post :create, :prayer_id => @prayer.id
      assert_template 'new'
    end
    
    context "when the model is valid" do
      setup do
        Comment.any_instance.stubs(:valid?).returns(true)
        post :create, :prayer_id => @prayer.id
      end
      should "redirect to the prayer" do
        assert_redirected_to prayer_url(assigns(:prayer))
      end
      should "set the comment user" do
        assert_equal @user, assigns(:comment).user
      end
    end    
    should "only create comments for prayers I have access"
  end
  
  context "on PUT to :update" do
    should "render new template when model is invalid" do
      Comment.any_instance.stubs(:valid?).returns(false)
      put :update, :prayer_id => @prayer.id, :id => @comment.id
      assert_template 'edit'
    end
    
    context "when the model is valid" do
      setup do
        Comment.any_instance.stubs(:valid?).returns(true)
        put :update, :prayer_id => @prayer.id, :id => @comment.id
      end
      should "redirect to the prayer" do
        assert_redirected_to prayer_url(assigns(:prayer))
      end
    end
    should "only edit comments that I own"
  end
  

  # 
  # 
  # context "index action" do
  #   should "render index template" do
  #     get :index, :prayer_id => @prayer
  #     assert_template 'index'
  #   end
  # end
  # 
  # context "show action" do
  #   should "render show template" do
  #     get :show, :id => Comment.first
  #     assert_template 'show'
  #   end
  # end
  # 
  # context "new action" do
  #   should "render new template" do
  #     get :new
  #     assert_template 'new'
  #   end
  # end
  # 
  # context "create action" do
  #   should "render new template when model is invalid" do
  #     Comment.any_instance.stubs(:valid?).returns(false)
  #     post :create
  #     assert_template 'new'
  #   end
  #   
  #   should "redirect when model is valid" do
  #     Comment.any_instance.stubs(:valid?).returns(true)
  #     post :create
  #     assert_redirected_to comment_url(assigns(:comment))
  #   end
  # end
  # 
  # context "edit action" do
  #   should "render edit template" do
  #     get :edit, :id => Comment.first
  #     assert_template 'edit'
  #   end
  # end
  # 
  # context "update action" do
  #   should "render edit template when model is invalid" do
  #     Comment.any_instance.stubs(:valid?).returns(false)
  #     put :update, :id => Comment.first
  #     assert_template 'edit'
  #   end
  # 
  #   should "redirect when model is valid" do
  #     Comment.any_instance.stubs(:valid?).returns(true)
  #     put :update, :id => Comment.first
  #     assert_redirected_to comment_url(assigns(:comment))
  #   end
  # end
  # 
  # context "destroy action" do
  #   should "destroy model and redirect to index action" do
  #     comment = Comment.first
  #     delete :destroy, :id => comment
  #     assert_redirected_to comments_url
  #     assert !Comment.exists?(comment.id)
  #   end
  # end
end
