require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  should_belong_to :prayer, :user
  should_validate_presence_of :body
  should_not_allow_mass_assignment_of :prayer_id, :user_id
  
  should "mark the thread updated when saved" do
    prayer = Factory(:prayer)
    prayer.expects(:update_attribute).with(:thread_updated_at, kind_of(Time))
    comment = Factory(:comment, :prayer => prayer)
  end
  
  should "create an intercession on create if asked" do
    Intercession.expects(:create)
    comment = Factory(:comment, :intercede => '0')
    comment = Factory(:comment, :intercede => '1')
  end
end
