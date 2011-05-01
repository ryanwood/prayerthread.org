class Prayer < ActiveRecord::Base
  attr_accessible :title, :body, :answer, :praise, :group_ids

  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :updates, :class_name => "Comment", :conditions => 'user_id = #{user_id}'
  has_many :audience_comments, :class_name => "Comment", :conditions => 'user_id != #{user_id}'
  has_many :activities, :order => 'created_at DESC', :dependent => :destroy
  has_many :intercessions, :dependent => :destroy
  has_many :nudges, :dependent => :destroy
  
  has_and_belongs_to_many :groups
  
  before_create :mark_thread_updated
  before_update :timestamp_answer
  
  delegate :name, :to => :user
  
  has_friendly_id :title, :use_slug => true
  
  scope :all, where('1=1')
  scope :open, where("answered_at IS NULL and praise = ?", false)
  scope :answered, where("answered_at IS NOT NULL and praise = ?", false)
  scope :praise, where("praise = ?", true)
  scope :for_user, lambda { |user|
    includes(:groups, :user).
    where('groups.id IN (?) OR prayers.user_id = ?', user.groups.map {|g| g.id }, user.id).
    order('prayers.thread_updated_at DESC')
  }
  scope :created_or_updated_this_week, where("thread_updated_at > ?", 7.days.ago)
  scope :within_groups, lambda { |groups| 
    includes(:groups).
    where('groups.id IN (?)', groups.map {|g| g.id }).
    order('prayers.thread_updated_at DESC')
  }
  
  VIEWS = [ :all, :open, :answered, :praise ]
  
  def self.per_page
    15
  end
  
  def self.view(view)
    VIEWS.include?(view) ? send(view) : send(:all)
  end
  
  # def self.find_view_for(view, user)
  #   view == :all ? for_user(user) : send(view).for_user(user)
  # end
  # 
  # def self.find_view_by(view, user, viewer)
  #   view == :all ? by_user(user) : send(view).by_user(user)
  #   view.within_groups(viewer.groups)
  # end
  
  def answered?
    !answered_at.nil?
  end

  def intercessors
    @intercessors ||= intercessions.map {|i| i.user }.uniq
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
