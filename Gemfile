source 'http://rubygems.org'

gem 'rails', '3.0.3'
gem 'mysql2'
gem 'haml'
gem 'clearance', :git => "git://github.com/thoughtbot/clearance.git"
gem "formtastic", '~> 1.1.0'
gem 'cancan'           #, '1.0.2'
gem 'friendly_id'      #, '2.2.7'
gem "will_paginate", "~> 3.0.pre2"    #, '~> 2.3.11'
gem 'daemon-spawn' # Needed for delayed job backgrounding
gem 'delayed_job', "~> 2.1.0.pre2"
gem 'hoptoad_notifier' #, '2.3.2'
gem 'gravtastic'       #, '~> 2.2'
gem 'compass', '>= 0.10.2'
gem 'capistrano'
gem 'settingslogic'

group :development do
  gem "haml-rails", :git => "http://github.com/indirect/haml-rails.git"    # need git for mailer generator

  # http://iain.nl/2010/07/customizing-irb-2010-edition/
  gem "wirble" 
  gem "hirb" 
  gem "awesome_print", :require => "ap" 
  # gem "interactive_editor" 

  # N+1 helper
  gem 'ruby-growl'
  gem 'bullet', '~> 2.0.0.rc1'
end

# Needed for rake tasks as a railstie
# http://blog.davidchelimsky.net/2010/07/11/rspec-rails-2-generators-and-rake-tasks/
# http://blog.davidchelimsky.net/2010/07/11/rspec-rails-2-generators-and-rake-tasks-part-ii/
group :development, :test do
  gem "rspec", ">= 2.0.1"
  gem "rspec-rails", ">= 2.0.1"
  gem 'steak', :git => 'git://github.com/cavalle/steak.git'
end

group :test do
  gem "shoulda"
  gem "capybara", ">= 0.3.9"
  gem "machinist", ">= 2.0.0.beta2"
  gem "faker"
  gem "database_cleaner"
end
