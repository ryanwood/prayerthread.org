set :ssh_flags,             '-p 22022'
set :application,           'prayerthread.org'
set :domain,                '208.78.97.190'
set :deploy_to,             '/var/www/prayerthread.org'
set :revision,              'master'
set :repository,            'git@sourcescape.unfuddle.com:sourcescape/prayerthread.git'


namespace :vlad do
  set :web_command, "/etc/init.d/nginx"
  
  desc 'Restarts the nginx server'
  remote_task :restart_web, :roles => :app do
    run "sudo #{web_command} restart"
  end

  desc 'Symlinks your custom directories'
  remote_task :symlink, :roles => :app do
    run "ln -s #{shared_path}/database.yml #{current_release}/config/database.yml"
  end
 
  desc 'Full deployment cycle: update, migrate, restart, cleanup'
  task :deploy => ['vlad:update', 'vlad:symlink', 'vlad:migrate', 'vlad:start_app', 'vlad:cleanup']
  
end