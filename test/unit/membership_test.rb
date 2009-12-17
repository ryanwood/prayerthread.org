require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  should_belong_to :user, :group
end
