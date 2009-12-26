require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  def setup
    @membership = Factory(:membership)
  end
  subject { @membership }
  should_belong_to :user, :group
  should_validate_uniqueness_of( :user_id, :scoped_to => :group_id )
end
