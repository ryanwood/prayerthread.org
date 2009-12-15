require 'test_helper'

class PrayerTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Prayer.new.valid?
  end
end
