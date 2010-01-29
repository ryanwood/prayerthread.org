require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  def setup
    @user = Factory(:email_confirmed_user)
    @prayer = Factory(:prayer, :user => @user)
    @comment = Factory(:comment, :prayer => @prayer, :user => @user)
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
        delete :edit, :id => @comment, :prayer_id => @prayer
      end
      should_be_denied
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
        delete :destroy, :id => @comment, :prayer_id => @prayer
      end
      should_be_denied
    end
  end
  
  context "on POST to :create" do
    context "for a prayer I have access to" do
      setup do
        Notification.stubs(:process)
        Prayer.any_instance.stubs(:groups).returns([@group])
        User.any_instance.stubs(:groups).returns([@group])
      end
    
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
      
      should "fired a comment created notification" do
        Notification.expects(:fire).with(:created, instance_of(Comment))
        post :create, :prayer_id => @prayer.id
      end
    end
    
    context "for a prayer I don't have access to" do
      should "not create a comment" do
        Comment.any_instance.stubs(:valid?).returns(true)
        Comment.any_instance.expects(:create).never
        post :create, :prayer_id => Factory(:prayer).id
      end
    end
  end
  
  context "on PUT to :update" do
    should "render new template when model is invalid" do
      Comment.any_instance.stubs(:valid?).returns(false)
      put :update, :prayer_id => @prayer.id, :id => @comment.id
      assert_template 'edit'
    end
    
    should "redirect to the prayer when the model is valid" do
      Comment.any_instance.stubs(:valid?).returns(true)
      put :update, :prayer_id => @prayer.id, :id => @comment.id
      assert_redirected_to prayer_url(assigns(:prayer))
    end

    should "only edit comments that I own" do
      Comment.any_instance.expects(:user).returns(Factory(:user))
      Comment.any_instance.expects(:update).never
      put :update, :prayer_id => @prayer.id, :id => @comment.id
    end
  end
end
