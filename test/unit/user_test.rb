require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should_validate_presence_of :first_name, :last_name
  should_allow_mass_assignment_of :first_name, :last_name
  should_have_many :groups
end
