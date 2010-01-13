class User < ActiveRecord::Base
  include Clearance::User
  attr_accessor :invitation_token
  attr_accessible :first_name, :last_name, :invitation_token
  
  after_create :add_recipient_to_invitation
  
  has_many :prayers
  has_many :comments
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :owned_groups, :class_name => "Group", :foreign_key => "owner_id"
  has_many :invitations, :foreign_key => "recipient_id"
  
  validates_presence_of :first_name, :last_name
  
  def name
    "#{first_name} #{last_name}"
  end
  
  # Any user that is in a shared group
  def related_users
    User.all( 
      :select => 'DISTINCT users.*',
      :joins => :groups, 
      :conditions => ["groups.id IN (?)", groups],
      :order => "users.first_name, users.last_name" )
  end
  
  # override clearance to auto accept the first invite
  def confirm_email!
    super
    accept_invitation!
  end
  
  protected
  
  def add_recipient_to_invitation
    if invitation_token
      invitation = Invitation.find_by_token(invitation_token) 
      if invitation
        self.invitations << invitation
        save(false)
        invitation_token = nil
      end
    end
  end
  
  def accept_invitation!
    invitations.first.accept!(self) if invitations.size == 1
  end
end
