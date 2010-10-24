require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'

RSpec.configuration.include Capybara, :type => :acceptance

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# For capybara to recognize Rails routes
include Rails.application.routes.url_helpers

# I guess including the above wipes out the default options... set it again.
Rails.application.config.action_mailer.default_url_options = { :host => 'prayerthread.local' }
