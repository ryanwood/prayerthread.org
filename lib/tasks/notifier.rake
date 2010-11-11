namespace :notifier do
  desc "Send email reminders"
  task :remind => :environment do
    User.remindable.each do |user|
      NotificationMailer.remind(user).deliver
    end
  end
end