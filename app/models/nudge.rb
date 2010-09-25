class Nudge < Activity
  
  after_create :notify_user
  
  def action_text
    "nudged you for an update on"
  end
  
  # Only allow 1 nudge per week
  def self.allowed?(user, prayer)
    return false if prayer.thread_updated_at < 1.day.ago
    @nudges_in_rolling_week ||= self.rolling_week
    @nudges_in_rolling_week.find{ |n| n.prayer == prayer && n.user == user }.nil?
  end
  
  protected
  
  def notify_user
    NotificationMailer.deliver_nudge(self)
  end
  
end
