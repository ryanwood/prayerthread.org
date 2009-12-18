require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  should_validate_presence_of :recipient_email
  should_not_allow_mass_assignment_of :sender, :group_id, :sent_at
  
  context "on save" do
    should "generate a token" do
      invitation = Factory.build(:invitation)
      assert_nil invitation.token
      invitation.save
      assert_not_nil invitation.token
      assert_equal 40, invitation.token.size
    end
    
    should "send an invitation" do
      InvitationMailer.expects(:deliver_invitation)
      invitation = Factory(:invitation)
      assert_not_nil invitation.sent_at
      assert_kind_of Time, invitation.sent_at
    end    
  end
  
  context "when accepted" do
    setup do
      @invitation = Factory(:invitation)
      @acceptor = Factory(:user)
      Membership.expects(:create)
      assert !@invitation.accepted?
      @invitation.accept!(@acceptor)
    end
    should "create a membership" do
      assert @invitation.accepted?
    end
    should "set accepted_at" do
      assert_not_nil @invitation.accepted_at
    end
    should "set accepted_user_id" do
      assert_not_nil @invitation.accepted_user_id
    end
  end
  
  
end
