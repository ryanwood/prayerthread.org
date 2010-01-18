require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should_validate_presence_of :first_name, :last_name
  should_allow_mass_assignment_of :first_name, :last_name, :invitation_token
  should_have_many :prayers, :memberships, :invitations, :comments, :owned_groups
  should_have_many :groups, :through => :memberships
  
  should "accept the first invitation when confirming an email" do
    user = Factory(:user)
    invite = Factory(:invitation, :recipient_id => user.id)
    assert !user.invitations.first.accepted?
    user.confirm_email!
    assert user.invitations.first.accepted?
  end
  
  should "have a name" do
    user = Factory.build(:user, :first_name => 'Ryan', :last_name => 'Wood')
    assert_equal "Ryan Wood", user.name
  end
  
  should "have a full email with name" do
    user = Factory.build(:user)
    assert_equal "#{user.first_name} #{user.last_name} <#{user.email}>", user.full_email
  end
  
  context "After create" do
    setup do
      @invitation = Factory(:invitation)
      @user = Factory.build(:user)
    end
    should "not add an invitation if there is a bad token" do
      @user.invitation_token = 'BADTOKEN'
      @user.invitations.expects(:<<).never
      @user.save(false)
    end

    should "add an invitation if there is a good token" do
      @user.invitation_token = @invitation.token
      @user.invitations.expects(:<<).with(@invitation)
      @user.save(false)
    end
  end
  
  
  

  
end
