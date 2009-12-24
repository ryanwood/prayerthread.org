class Comment < ActiveRecord::Base
  attr_accessible :body
  belongs_to :prayer
  belongs_to :user
  validates_presence_of :body, :on => :create, :message => "can't be blank"
  
  named_scope :recent, :order => 'created_at DESC', :limit => 5
end
