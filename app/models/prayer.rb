class Prayer < ActiveRecord::Base
  attr_accessible :title, :body, :answered, :group_ids

  belongs_to :user
  has_many :comments, :order => 'created_at DESC'
  has_and_belongs_to_many :groups
  
  before_create :mark_thread_updated
  
  delegate :name, :to => :user
  
  named_scope :all_for, lambda { |user|
    groups = user.groups 
    {
      :select => "DISTINCT prayers.*",
      :include => :groups, 
      :conditions => ['groups.id IN (?) OR prayers.user_id = ?', groups.map {|g| g.id }, user.id],
      :order => 'prayers.thread_updated_at DESC'
    }
  }
  
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
  
  protected
  
  def mark_thread_updated
    self.thread_updated_at = Time.now
  end
  
end
