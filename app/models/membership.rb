class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates_uniqueness_of :user_id, :scope => :group_id, :on => :create
  
  ROLES = %w[member owner]

  def self.role_options
    ROLES.map { |r| [r.humanize, r] }
  end
  
  def self.default_role
    ROLES[0]
  end
end
