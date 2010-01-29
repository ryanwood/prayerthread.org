class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  before_save :set_notifications
  
  attr_accessible :notification_level, :group, :user
  
  validates_presence_of :group, :user
  validates_uniqueness_of :user_id, :scope => :group_id, :on => :create
  
  NOTIFICATION_LEVELS = [
    [ "when a prayer is created, updated, or answered", 1 ],
    [ "...also when a comment is added to one of my prayers", 2 ],
    # [ "...plus when a comment is added to any member's prayer", 3 ],
    [ "never", 0 ]
  ]
  
  ROLES = %w[member owner]

  def self.role_options
    ROLES.map { |r| [r.humanize, r] }
  end
  
  def self.default_role
    ROLES[0]
  end
  
  protected
  
    def set_notifications
      # Default to level 2 if nil
      self.notification_level ||= 2
      # Clear them out
      notifications.each { |n| self[n] = false }
      # Set the notifications for each level
      notifications[0..2].each { |n| self[n] = true } if self.notification_level > 0
      self[notifications[3]] = true if self.notification_level > 1
    end
    
    def notifications 
      [ :notify_on_prayer_created, 
        :notify_on_prayer_answered, 
        :notify_on_comment_from_originator, 
        :notify_on_comment_to_originator ]
    end
end
