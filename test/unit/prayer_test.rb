require 'test_helper'

class PrayerTest < ActiveSupport::TestCase
  should_belong_to :user
  should_not_allow_mass_assignment_of :user
end
