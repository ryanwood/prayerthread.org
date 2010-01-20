require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  should_allow_mass_assignment_of :name, :owner_id
  should_belong_to :owner
  should_have_many :memberships, :dependent => :destroy
  should_have_many :users, :through => :memberships
  should_have_many :invitations
  should_have_and_belong_to_many :prayers
  
  should_validate_presence_of :name, :owner
  
  context "After create" do
    should "ensure that the owner is a member" do
      group = Factory.build(:group)
      assert group.memberships.empty?
      assert group.save
      assert !group.memberships.empty?
    end
  end
end
