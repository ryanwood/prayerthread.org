# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin
  require 'vlad'
  # This is a patched gem to fix the following bugs:
  # http://github.com/inbox/413649#reply
  #
  # sudo gem install ktheory-vlad-git
  #
  Vlad.load :scm => :git, :app => :passenger
rescue LoadError
  puts 'Could not load Vlad'
end