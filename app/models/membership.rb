class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  before_create :set_defaults
  
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
  
    def set_defaults
      self.notification_level = 2 unless self.notification_level
    end
end
