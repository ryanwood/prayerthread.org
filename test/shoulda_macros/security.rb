# test/shoulda_macros/security.rb
  class Test::Unit::TestCase
    def self.should_be_denied(opts = {})
      should_render_template :no_access
    end
  end