require 'test_helper'

class PrayerTest < ActiveSupport::TestCase
  should_belong_to :user
  should_allow_mass_assignment_of :title, :body, :answered, :group_ids
  should_not_allow_mass_assignment_of :user, :prayer
  should_have_db_column :thread_updated_at, :answered
  
  context "on create" do
    should "populate the thread_updated_at field" do
      prayer = Factory(:prayer)
      assert_not_nil prayer.thread_updated_at
    end
  end
  
end
