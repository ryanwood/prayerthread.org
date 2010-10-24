module Clearance
  module Shoulda
    module Helpers
      def sign_in_as(user)
        @controller.current_user = user
        return user
      end

      def sign_in
        sign_in_as ::User.make(:confirmed)
      end

      def sign_out
        @controller.current_user = nil
      end
    end
  end
end

RSpec.configuration.include Clearance::Shoulda::Helpers, :type => :controller
