class User < ActiveRecord::Base
  include Clearance::User
  is_gravtastic!
  attr_accessor :invitation_token
  
  after_create :add_recipient_to_invitation
  
  has_many :prayers
  has_many :comments
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :owned_groups, :class_name => "Group", :foreign_key => "owner_id"
  has_many :invitations, :foreign_key => "recipient_id"
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => "sender_id"
  has_many :intercessions
  
  # From the account page
  accepts_nested_attributes_for :memberships
  
  validates_presence_of :first_name, :last_name
  
  # Any user that shares a group
  scope :related, lambda { |user, *excluded|
    joins( :groups ).
    where( "groups.id IN (?) and users.id NOT IN (?)", user.groups, excluded << user ).
    order( "users.first_name, users.last_name" ).
    group( "users.id" )
  }
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def full_email
    "#{name} <#{email}>"
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
        update_attribute :invitation_token, nil
      end
    end
  end
  
  def accept_invitation!
    invitations.first.accept!(self) if invitations.size == 1
  end
end
