require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  should_validate_presence_of :recipient_email
  should_not_allow_mass_assignment_of :sender, :group_id, :sent_at
end
