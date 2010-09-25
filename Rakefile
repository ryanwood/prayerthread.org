# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Prayerthread::Application.load_tasks

begin
  require 'delayed/tasks'
rescue LoadError
  STDERR.puts "Run `rake gems:install` to install delayed_job"
end

namespace :sass do
  desc 'Updates stylesheets if necessary from their Sass templates.'
  task :update => :environment do
    sh "rm -rf public/stylesheets/compiled tmp/sass-cache"
    Sass::Plugin.options[:never_update] = false
    Sass::Plugin.update_stylesheets
  end
end
