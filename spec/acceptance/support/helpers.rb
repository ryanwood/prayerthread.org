module HelperMethods

  def sign_in_as(email_or_user, password = 'password')
    email = email_or_user.is_a?(User) ? email_or_user.email : email_or_user
    visit "/sign_in"
    fill_in "Email", :with => email
    fill_in "Password", :with => password
    click_button "Sign in"
  end

# [:notice, :error].each do |name|
#   define_method "should_have_#{name}" do |message|
#     page.should have_css(".message.#{name}", :text => message)
#   end
# end

  def should_be_on(path)
    page.current_url.should match(Regexp.new(path))
  end

  def should_not_be_on(path)
    page.current_url.should_not match(Regexp.new(path))
  end

  def should_have_errors
    page.should have_content('problems with the following fields')
  end

  def should_see(text)
    page.should have_content(text)
  end

  def should_be_signed_in
    visit homepage
    page.should have_content("Sign Out")
  end

  def should_be_signed_out
    visit homepage
    page.should have_content("Sign In")
  end


end

RSpec.configuration.include HelperMethods, :type => :acceptance
