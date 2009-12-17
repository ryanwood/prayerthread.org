require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    # @group = Factory(:group)
  end
  
  should_validate_presence_of :name
end
