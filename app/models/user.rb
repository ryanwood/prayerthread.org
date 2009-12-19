class User < ActiveRecord::Base
  include Clearance::User
  attr_accessor :invitation_id
  attr_accessible :first_name, :last_name, :invitation_id
  
  has_many :prayers
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :owned_groups, :class_name => "group", :foreign_key => "owner_id"
  has_one :invitation, :foreign_key => "accepted_user_id"
  
  validates_presence_of :first_name, :last_name
  
  def prayer_thread
    @prayer_thread = Prayer.for_groups(groups)
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def accept_invitation!
    invitation = Invitation.find(invitation_id)
    invitation.accept!(self) if invitation
  end
  
  def pending_invitations
    @pending_invitations ||= Invitation.pending.find_all_by_recipient_email(email)
  end
  
end
