namespace :notifications do
  desc 'Run all available notifications'
  task send: :environment do
    Notification.not_sent.find_each do |notification|
      notification.send!
    end
  end
end
