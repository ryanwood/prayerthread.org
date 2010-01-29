require File.dirname(__FILE__) + '/../test_helper'

class PrayersControllerTest < ActionController::TestCase
  
  def setup
    @user = Factory(:email_confirmed_user)
    @group = Factory(:group, :owner => @user)
    @prayer = Factory(:prayer, :user => @user, :groups => [@group])
    @prayer_not_allowed = Factory(:prayer, :user => Factory(:email_confirmed_user))
    sign_in_as @user
  end
  
  context "on GET to :index" do
    setup { get :index }
    should_assign_to :prayers
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
    
    should "only show prayers in my groups" do
      assert_equal Prayer.count, 2
      assert_equal assigns(:prayers).size, 1
    end
  end
  
  context "on GET to :show" do
    
    context "with prayer in my groups" do
      setup do
        get :show, :id => @prayer.id
      end
      should_assign_to :prayer, :recent_comments
      should_respond_with :success
      should_render_template :show
      should_not_set_the_flash
    end
    
    context "with prayer outside my groups" do
      setup { get :show, :id => @prayer_not_allowed.id }
      should_be_denied
    end
  end
  
  context "on GET to :new" do
    should "be successful" do
      get :new
      assert_response :success
    end
     context "the new form" do
      should "only show groups they can post to" do
        allowed = Factory(:group, :name => 'Allowed Group')
        forbidden = Factory(:group, :name => "Forbidden Group")
        @user.groups << allowed
        get :new
        assert_select 'li#prayer_groups_input' do
          assert_select 'label', 'Allowed Group'
          assert_select 'label', :count => 0, :text => "Forbidden Group"
        end
      end
    end
  end
  
  context "on POST to :create" do
    setup do
      Prayer.any_instance.stubs(:title).returns("My Prayer") # For friendly_id
    end
    context "when model is invalid" do
      setup do
        Prayer.any_instance.stubs(:valid?).returns(false)
        post :create
      end
      should_render_template :new
    end
    
    context "when model is valid" do
      setup do
        Prayer.any_instance.stubs(:valid?).returns(true)
        post :create
      end
      should_change( "the number of prayers", :by => 1 ) { Prayer.count }
      should_redirect_to( "the prayer" ) { prayer_path(assigns(:prayer)) }
    end
    should "fired a prayer created notification" do
      Notification.expects(:fire).with(:created, instance_of(Prayer))
      post :create
    end
  end
  
  context "on GET to :edit" do
    context "a request" do
      setup { get :edit, :id => @prayer }
      should_assign_to :prayer
      should_respond_with :success
      should_render_template :edit
      should_not_set_the_flash
    end
  end
  
  context "on PUT to :update" do
    should "redirect_to the prayer" do
      put :update, :id => @prayer
      assert_redirected_to prayer_path(assigns(:prayer))
    end
    should "update the prayer's title" do
      put :update, :id => @prayer, :prayer => { :title => "Updated Title" }
      assert assigns(:prayer).title == "Updated Title"
    end
    should "fire the answered notification if the prayer was answered" do
      Notification.expects(:fire).with(:answered, @prayer)
      put :update, :id => @prayer, :prayer => { :answer => "My answer" }
    end
    should "not fire the answered notification unless the prayer was answered" do
      Notification.expects(:fire).never
      put :update, :id => @prayer
    end
  end
  
  context "on DELETE to :destroy" do
    setup { delete :destroy, :id => @prayer }
    should_change( "the number of prayers", :by => -1 ) { Prayer.count }
    should_redirect_to( "the prayer list" ) { prayers_url }
  end
end
