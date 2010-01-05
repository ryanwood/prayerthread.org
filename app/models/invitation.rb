require 'digest/sha1'

class Invitation < ActiveRecord::Base
  attr_accessible :recipient_email
  
  belongs_to :group
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"
  
  validates_presence_of :recipient_email, :on => :create, :message => "can't be blank"
  validates_format_of :recipient_email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_uniqueness_of :recipient_email, :scope => :group_id, :on => :create, :message => "has already been invited to this group"
  
  before_save :initialize_invitation_token
  
  named_scope :pending, :conditions => { :accepted_at => nil, :ignored => false }
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
  
  protected

  def generate_invitation_token
    self.token = Digest::SHA1.hexdigest("--#{Time.now.utc}--#{recipient_email}--")
  end

  def initialize_invitation_token
    generate_invitation_token if new_record?
  end

  def send_invitation_email
    InvitationMailer.deliver_invitation( self )
    update_attribute :sent_at, Time.now
  end
end