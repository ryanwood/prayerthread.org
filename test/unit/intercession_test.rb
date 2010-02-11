require 'test_helper'

class IntercessionTest < ActiveSupport::TestCase
  should_belong_to :user, :prayer
end
