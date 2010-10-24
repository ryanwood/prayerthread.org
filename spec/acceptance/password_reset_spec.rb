require File.dirname(__FILE__) + '/acceptance_helper'

feature "Password Reset", %q{
  In order to to sign in even if user forgot their password
  As a user
  I want to reset it
} do

  scenario "User is not signed up" do
    User.find_by_email('email@person.com').should be_nil
    visit new_password_path
    fill_in "Email address", :with => 'email@person.com'
    click "Reset password"
    should_see "Unknown email"
  end

  scenario "User is signed up and requests password reset" do
    user = User.make!(:confirmed)
    visit new_password_path
    fill_in "Email address", :with => user.email
    click "Reset password"
    should_see "instructions for changing your password"
    should_be_on sign_in_path
  end

  scenario "User is signed up reset his password and types wrong confirmation" do
    user = User.make!(:confirmed)
    visit( edit_user_password_path(
      :user_id => user,
      :token   => user.confirmation_token))
    fill_in "Choose password", :with => 'mynewpassword' 
    fill_in "Confirm password", :with => 'notmynewpassword' 
    click "Save this password"
    should_have_errors
    should_be_signed_out
  end

  scenario "User is signed up and updates his password" do
    user = User.make!(:confirmed)
    visit( edit_user_password_path(
      :user_id => user,
      :token   => user.confirmation_token))
    fill_in "Choose password", :with => 'newpassword' 
    fill_in "Confirm password", :with => 'newpassword' 
    click "Save this password"
    should_be_signed_in
    visit sign_out_path
    sign_in_as user, 'newpassword'
    should_be_signed_in
  end

end
