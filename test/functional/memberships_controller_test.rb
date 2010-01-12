require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  def setup
    @owner_user = Factory(:email_confirmed_user)
    @member_user = Factory(:email_confirmed_user)
    @not_allowed_user = Factory(:email_confirmed_user)
    @group = Factory(:group, :owner => @owner_user )
    @membership = Factory(:membership, :group => @group, :user => @member_user)
  end
  context "on DELETE to :destroy" do

    context "when not authenticated" do
      setup { delete :destroy, :group_id => @group, :id => @membership }
      should_redirect_to( "sign in" ) { new_session_url }
    end
    
    context "when authenticated" do
      setup { sign_in_as @not_allowed_user }
      should "only delete my memberships" do
        Membership.any_instance.expects(:destroy).never
        delete :destroy, :group_id => @group, :id => @membership
      end
    end
    
    context "when authenticated as the group owner" do
      setup { sign_in_as @owner_user }
      should "not delete their membership in the group" do
        membership = Membership.find_by_user_id( @owner_user )
        Membership.any_instance.expects(:destroy).never
        delete :destroy, :group_id => @group, :id => membership
      end
      should "delete any other membership in the group" do
        Membership.any_instance.expects(:destroy)
        delete :destroy, :group_id => @group, :id => @membership
      end
      should "redirect to the group's memberships" do
        delete :destroy, :group_id => @group, :id => @membership
        assert_redirected_to group_memberships_url(@group)
      end
    end

    context "when authenticated as a group member" do
      setup { sign_in_as @member_user }
      should "delete any of my the membership" do
        Membership.any_instance.expects(:destroy)
        delete :destroy, :group_id => @group, :id => @membership
      end
      should "redirect to the group's memberships" do
        delete :destroy, :group_id => @group, :id => @membership
        assert_redirected_to group_memberships_url(@group)
      end
    end
  end
  
end
