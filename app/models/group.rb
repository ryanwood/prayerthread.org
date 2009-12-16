class Group < ActiveRecord::Base
  attr_accessible :name
  belongs_to :owner, :class_name => "User"
  has_many :memberships
  has_many :users, :through => :memberships
  
  after_create :ensure_owner_is_a_member
  
  validates_presence_of :owner, :on => :create, :message => "can't be blank"
  
  protected
  
  def ensure_owner_is_a_member
    memberships.create( :user => self.owner )
  end
end
