class User < ActiveRecord::Base
  include Clearance::User
  
  attr_accessible :first_name, :last_name, :invitation_id
  
  has_many :prayers
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :owned_groups, :class_name => "group", :foreign_key => "owner_id"
  belongs_to :invitation
  
  validates_presence_of :first_name, :last_name
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def accept_invitation!
    invitation.accept! if invitation
  end
end
