class Comment < ActiveRecord::Base
  attr_accessible :body
  belongs_to :prayer, :counter_cache => true
  belongs_to :user
  validates_presence_of :body, :on => :create, :message => "can't be blank"
  
  named_scope :recent, :order => 'created_at DESC', :limit => 5
  
  after_save :mark_thread_updated
  
  protected
  
  def mark_thread_updated
    prayer.update_attribute :thread_updated_at, self.updated_at
  end
end
