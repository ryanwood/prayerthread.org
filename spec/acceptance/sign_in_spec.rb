require File.dirname(__FILE__) + '/acceptance_helper'

feature "Sign In", %q{
  In order to get access to protected sections of the site
  As a user
  I want to sign in
} do

  scenario "User is not signed up" do
    user = User.make
    User.find_by_email(user.email).should be_nil
    visit sign_in_path
    sign_in_as user
    should_see "Bad email or password"
    should_be_signed_out
  end

  scenario "User is not confirmed" do
    user = User.make!
    visit sign_in_path
    sign_in_as user
    should_see "User has not confirmed email"
    should_be_signed_out    
  end

  scenario "User enters wrong password" do
    user = User.make!(:confirmed)
    visit sign_in_path
    sign_in_as user, 'badpa$$word'
    should_see "Bad email or password"
    should_be_signed_out  
  end

  scenario "User signs in successfully" do
    user = User.make!(:confirmed)
    visit sign_in_path
    sign_in_as user
    should_see "Signed in"
    should_be_signed_in
    visit root_path 
    should_be_signed_in
  end
  
end
