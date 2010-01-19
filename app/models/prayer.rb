class Prayer < ActiveRecord::Base
  attr_accessible :title, :body, :answer, :group_ids

  belongs_to :user
  has_many :comments, :order => 'created_at DESC', :dependent => :destroy
  has_and_belongs_to_many :groups
  
  before_create :mark_thread_updated
  before_update :timestamp_answer
  
  delegate :name, :to => :user
  
  has_friendly_id :title, :use_slug => true
  
  def self.find_for(id, user)
    Prayer.first(
      :include => :groups,
      :conditions => [
        "prayers.id = ? AND (prayers.user_id = ? OR groups.id IN (?))", 
        id.to_i, 
        user.id, 
        user.groups]
    )
  end
  
  def self.per_page
    15
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
