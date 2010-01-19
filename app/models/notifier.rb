class Notifier < ActiveRecord::Observer
  
  observe :prayer, :comment
  
  def after_create(model)
    notify_prayer_created(model)
    notify_prayer_commented_by_owner(model)
  end
  
  protected
  
    def logger
      @logger ||= RAILS_DEFAULT_LOGGER
    end
    
    def notify_prayer_created(prayer)
      if prayer.is_a?(Prayer)
        recipients_for(prayer, 1).each do |recipient|
          NotificationMailer.deliver_prayer_created(recipient, prayer)
        end
      end
    end
    
    def notify_prayer_commented_by_owner(comment)
      if comment.is_a?(Comment) && comment.user == comment.prayer.user
        recipients_for(comment.prayer, 1).each do |recipient|
          NotificationMailer.deliver_comment_created(recipient, comment)
        end
      end
    end
  
    def recipients_for(prayer, level)
      memberships = prayer.groups.map { |g| g.memberships.select {|m| m.notification_level >= level} }.flatten
      memberships.map { |m| m.user }.uniq - [prayer.user]
    end

    # NotificationMailer.send_later( :deliver_prayer_notification, recipient, self )
    # NotificationMailer.deliver_prayer_notification( recipient, self )
  
end