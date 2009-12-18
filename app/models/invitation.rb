require 'digest/sha1'

class Invitation < ActiveRecord::Base
  attr_accessible :recipient_email
  
  belongs_to :group
  belongs_to :sender, :class_name => "User"
  has_one :recipient, :class_name => "User"
  
  validates_presence_of :recipient_email, :on => :create, :message => "can't be blank"
  validates_format_of :recipient_email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  before_save :initialize_invitation_token
  
  named_scope :pending, :conditions => { :accepted_at => nil }
  after_create :send_invitation_email, :unless => :accepted?
  
  def accepted?
    !accepted_at.nil?
  end
  
  def accept!
    update_attribute :accepted_at, Time.now
    Membership.create( :user => recipient, :group => group )
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