require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  def setup
    @group = Factory(:group)
    sign_in_as @group.owner
  end
  
  context "on GET to :index" do
    setup do
      get :index
      @another_group = Factory(:group)
    end  
    should_assign_to :groups
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
  
  context "on GET to :show" do
    setup { get :show, :id => @group.id }
    should_assign_to :group
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end
  
  context "on GET to :new" do
    setup { get :new }
    should_respond_with :success
  end
  
  context "on POST to :create" do
    setup do
      Group.any_instance.stubs(:name).returns("The Group") # for friendly_id
    end
    context "when model is invalid" do
      setup do
        Group.any_instance.stubs(:valid?).returns(false)
        post :create
      end
      should_assign_to :group
      should_render_template :new
    end
    
    context "when model is valid" do
      setup do
        Group.any_instance.stubs(:valid?).returns(true)
        post :create
      end
      should_assign_to :group
      should_redirect_to( "the group members page" ) { group_memberships_path(assigns(:group)) }
    end
  end
  
  context "on GET to :edit" do
    setup { get :edit, :id => @group }
    should_assign_to :group
    should_respond_with :success
    should_render_template :edit
    should_not_set_the_flash
  end
  
  context "on PUT to :update" do
    setup { put :update, :id => @group, :group => { :name => "Updated Title" } }
    should_redirect_to( "the group" ) { group_path(assigns(:group)) }
    should "update the group's name" do
      assert assigns(:group).name == "Updated Title"
    end
  end
  
  context "on DELETE to :destroy" do
    setup { delete :destroy, :id => @group }
    should_change( "the number of groups", :by => -1 ) { Group.count }
    should_redirect_to( "the group list" ) { groups_url }
  end
  
end
