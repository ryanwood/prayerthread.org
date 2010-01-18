class Notifier < ActiveRecord::Observer
  
  observe :prayer, :comment
  
  # def after_create(model)
  #   if model.is_a?(Prayer)
  #     recipients_for(model, 1).each do |u|
  #       NotificationMailer.deliver_prayer_notification(recipient, model)
  #     end
  #   elsif model.is_a?(Comment)
  #     recipients_for(model, 1).each do |u|
  #       NotificationMailer.deliver_prayer_notification(recipient, model)
  #     end
  #   end
  # end
  
  protected
  
    def recipients_for(prayer, level)
      memberships = prayer.groups.map { |g| g.memberships.select {|m| m.notification_level >= level} }.flatten
      memberships.map {|m| m.user }.uniq - [prayer.user]
    end

    # NotificationMailer.send_later( :deliver_prayer_notification, recipient, self )
    # NotificationMailer.deliver_prayer_notification( recipient, self )
  
end