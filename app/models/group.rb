class Group < ActiveRecord::Base
  attr_accessible :name, :owner_id
  belongs_to :owner, :class_name => "User"
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :invitations
  
  after_create :ensure_owner_is_a_member
  
  validates_presence_of :name, :owner_id
  
  protected
  
  def ensure_owner_is_a_member
    memberships.create( :user => self.owner )
  end
end
