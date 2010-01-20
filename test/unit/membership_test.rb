require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  def setup
    @membership = Factory(:membership)
  end
  subject { @membership }
  should_belong_to :user, :group
  should_validate_presence_of :user, :group
  should_allow_mass_assignment_of :group, :user, :notification_level
  should_validate_uniqueness_of( :user_id, :scoped_to => :group_id )
  should "set the default notification level to 1" do
    m = Factory(:membership, :notification_level => nil)
    assert_equal 1, m.notification_level
  end
end
