require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  should_belong_to :user, :group
  should validate_uniqueness_of(:user_id).scoped_to(:group_id)  
end
