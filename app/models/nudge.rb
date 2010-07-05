class Nudge < Activity
  
  after_create :notify_user
  
  def action_text
    "nudged you for an update on"
  end
  
  # Only allow 1 nudge per week
  def self.allowed?(user, prayer)
    !self.actor(user).regarding(prayer).rolling_week.exists?
  end
  
  protected
  
  def notify_user
    NotificationMailer.deliver_nudge(self)
  end
  
end
