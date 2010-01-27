require 'digest/sha1'

class Invitation < ActiveRecord::Base
  attr_accessible :recipient_email
  
  belongs_to :group
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"
  
  validates_presence_of :group
  validates_presence_of :recipient_email, :on => :create, :message => "can't be blank"
  validates_format_of :recipient_email, 
    :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
    :message => "is not a valid email format, e.g. john@company.com"
  validate_on_create :membership_does_not_exist, :pending_invitation_does_not_exists
  
  before_save :initialize_invitation_token
  
  named_scope :pending, :conditions => { :accepted_at => nil, :ignored => false }, :order => "sent_at DESC"
  named_scope :pending_and_ignored, :conditions => { :accepted_at => nil }
  
  after_create :send_invitation_email, :unless => :accepted?
  
  def accepted?
    !accepted_at.nil?
  end
  
  def accept!(user)
    unless accepted?
      update_attribute( :accepted_at, Time.now )
      Membership.create( :group => self.group, :user => user )
    end
  end
  
  def send_invitation_email
    InvitationMailer.deliver_invitation( self )
    update_attribute :sent_at, Time.now
  end
  
  protected
  
    def membership_does_not_exist
      existing_user = User.find_by_email(recipient_email)
      if existing_user && Membership.exists?( :group_id => group, :user_id => existing_user )
        errors.add("recipient_email", "is already a member of this group")
      end
    end
    
    def pending_invitation_does_not_exists
      if Invitation.exists?( :group_id => group, :recipient_email => recipient_email, :accepted_at => nil )
        errors.add("recipient_email", "already has a pending invitation to this group")
      end
    end

    def generate_invitation_token
      self.token = Digest::SHA1.hexdigest("--#{Time.now.utc}--#{recipient_email}--")
    end

    def initialize_invitation_token
      generate_invitation_token if new_record?
    end

end