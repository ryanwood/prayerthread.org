require 'redcloth'

class Prayer < ActiveRecord::Base
  attr_accessible :title, :body, :answer, :group_ids

  belongs_to :user
  has_many :comments, :order => 'created_at DESC', :dependent => :destroy
  has_and_belongs_to_many :groups
  
  before_create :mark_thread_updated
  before_update :timestamp_answer
  
  delegate :name, :to => :user
  
  has_friendly_id :title, :use_slug => true
  
  named_scope :open, :conditions => "answered_at IS NULL" 
  named_scope :answered, :conditions => "answered_at IS NOT NULL" 
  named_scope :for, lambda { |user| {
    :include => :groups, 
    :conditions => ['groups.id IN (?) OR prayers.user_id = ?', user.groups.map {|g| g.id }, user.id],
    :order => 'prayers.thread_updated_at DESC'
  }}
  
  
  def self.per_page
    15
  end
  
  def self.find_view(view, user)
    send(view).for(user)
  end
  
  def answered?
    !answered_at.nil?
  end
  
  def to_html
    RedCloth.new(self.body).to_html
  end
  
  def to_preview
    to_html.gsub(/<(.|\n)*?>/, '')
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
