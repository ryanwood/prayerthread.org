set :application,   'prayerthread.org'
set :repository,    'git@sourcescape.unfuddle.com:sourcescape/prayerthread.git'
set :deploy_to,     "/var/www/#{application}"
set :port,          22022
set :scm,           :git
set :deploy_via,    :remote_cache

server "208.78.97.190", :app, :web, :db, :primary => true

# Callbacks
after "deploy:update_code", "db:symlink" 
after "deploy:restart", "delayed_job:restart"

# Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do
  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end