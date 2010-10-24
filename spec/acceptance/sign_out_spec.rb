require File.dirname(__FILE__) + '/acceptance_helper'

feature "Sign Out", %q{
  In order to protect my account from unauthorized access
  As a signed in user
  I want to sign out
} do

  scenario "User signs out" do
    user = User.make!(:confirmed)
    sign_in_as user
    should_be_signed_in
    visit sign_out_path
    should_see "Signed out"
    should_be_signed_out
    visit root_path
    should_be_signed_out
  end
end
