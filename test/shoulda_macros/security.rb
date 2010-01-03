# test/shoulda_macros/security.rb
  class Test::Unit::TestCase
    def self.should_be_denied(opts = {})
      should_set_the_flash_to(opts[:flash] || /Sorry/i)
      should_redirect_to('the root') { opts[:redirect] || root_url }
    end
  end