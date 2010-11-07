require File.dirname(__FILE__) + '/acceptance_helper'

feature "Sign Up", %q{
  In order to use the site
  As a new user
  I want to sign up
} do

  scenario "User signs up with invalid data" do
    visit '/sign_up'
    click_button 'Sign up'
    should_have_errors
  end

  scenario "User signs up with valid data" do
    visit '/sign_up'
    fill_in 'First name', :with => 'Ryan'
    fill_in 'Last name', :with => 'Wood'
    fill_in 'Email', :with => 'ryan.wood@gmail.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Confirm password', :with => 'password'
    click_button 'Sign up'
    should_see "You will receive an email within the next few minutes. It contains instructions for confirming your account."
    should_be_on "sign_in"
  end

  scenario "User confirms his account" do
    user = User.make!
    visit new_user_confirmation_path(
      :user_id => user,
      :token   => user.confirmation_token)
    should_see "Confirmed email and signed in"
    should_be_signed_in 
  end

  scenario "Signed in user clicks confirmation link again" do
    user = User.make!
    visit new_user_confirmation_path(
      :user_id => user,
      :token   => user.confirmation_token)
    should_be_signed_in
    visit new_user_confirmation_path(
      :user_id => user,
      :token   => user.confirmation_token)
    should_see "Confirmed email and signed in"
    should_be_signed_in 
  end  

  scenario "Signed out user clicks confirmation link again" do
    user = User.make!
    visit new_user_confirmation_path(
      :user_id => user,
      :token   => user.confirmation_token)
    should_be_signed_in
    click_link 'Sign Out'
    visit new_user_confirmation_path(
      :user_id => user,
      :token   => user.confirmation_token)
    should_see "Already confirmed email. Please sign in."
    should_be_signed_out
  end 
end
