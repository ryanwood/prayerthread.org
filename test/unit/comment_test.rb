require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  should_belong_to :prayer, :user
  should_validate_presence_of :body
  should_not_allow_mass_assignment_of :prayer_id, :user_id
end
