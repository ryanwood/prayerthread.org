class Prayer < ActiveRecord::Base
  attr_accessible :title, :body, :answer, :praise, :group_ids

  belongs_to :user
  has_many :comments, :order => 'created_at DESC', :dependent => :destroy
  has_many :updates, :class_name => "Comment", :conditions => 'user_id = #{user_id}', :order => 'created_at DESC'
  has_many :audience_comments, :class_name => "Comment", :conditions => 'user_id != #{user_id}', :order => 'created_at DESC'
  # has_many :comments, :order => 'created_at DESC', :dependent => :destroy
  has_many :activites, :order => 'created_at DESC', :dependent => :destroy
  has_many :intercessions
  has_many :nudges
  
  has_and_belongs_to_many :groups
  
  before_create :mark_thread_updated
  before_update :timestamp_answer
  
  delegate :name, :to => :user
  
  has_friendly_id :title, :use_slug => true
  
  named_scope :open, :conditions => "answered_at IS NULL and praise = false" 
  named_scope :answered, :conditions => "answered_at IS NOT NULL and praise = false" 
  named_scope :praise, :conditions => "praise = true"
  named_scope :for_user, lambda { |user| {
    :include => :groups, 
    :conditions => ['groups.id IN (?) OR prayers.user_id = ?', user.groups.map {|g| g.id }, user.id],
    :order => 'prayers.thread_updated_at DESC'
  }}
  
  VIEWS = [ :all, :open, :answered, :praise ]
  
  def self.per_page
    15
  end
  
  def self.find_view(view, user)
    view == :all ? for_user(user) : send(view).for_user(user)
  end
  
  def answered?
    !answered_at.nil?
  end
  
  protected
  
  def mark_thread_updated
    self.thread_updated_at = Time.now
  end
  
  def timestamp_answer
    if self.answer.blank?
      self.answered_at = self.answer = nil
    else
      self.answered_at = Time.now
    end
  end
  
end
