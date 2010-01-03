class Group < ActiveRecord::Base
  attr_accessible :name, :owner_id
  belongs_to :owner, :class_name => "User"
  has_many :memberships, :dependent => :destroy, :include => :user
  has_many :users, :through => :memberships
  has_many :invitations
  has_and_belongs_to_many :prayers
  
  has_friendly_id :name, :use_slug => true
  
  after_create :ensure_owner_is_a_member
  
  validates_presence_of :name, :owner_id
  
  protected
  
  def ensure_owner_is_a_member
    memberships.create( :user => self.owner )
  end
end
