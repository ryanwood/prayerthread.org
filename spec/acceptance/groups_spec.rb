require File.dirname(__FILE__) + '/acceptance_helper'

feature "Groups", %q{
  In order to ...
  As a ...
  I want to ...
} do

  let(:group) { Group.make! }
  let(:user) { User.make!(:confirmed) }

  background do
    sign_in_as user
  end

# scenario "Viewing a group I don't have access to" do
#   visit "/groups/#{group.to_param}"
#   page.should have_content("Sorry, we couldn't find that group.")
# end
end
