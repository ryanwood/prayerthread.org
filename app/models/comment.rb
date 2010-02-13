class Comment < ActiveRecord::Base
  attr_accessible :body, :intercede
  belongs_to :prayer, :counter_cache => true
  belongs_to :user
  validates_presence_of :body, :on => :create, :message => "can't be blank"
  
  named_scope :recent, :order => 'created_at DESC', :limit => 5
  
  after_save :mark_thread_updated
  after_create :create_intercession
  
  attr_reader :intercede
  def intercede=(val)
    @intercede = (val == '1')
  end
  
  protected
  
  def mark_thread_updated
    prayer.update_attribute :thread_updated_at, self.updated_at
  end
  
  def create_intercession
    Intercession.create( :prayer => prayer, :user => user ) if intercede
  end
end
