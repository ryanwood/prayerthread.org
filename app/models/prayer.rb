class Prayer < ActiveRecord::Base
  attr_accessible :title, :body, :group_ids
  belongs_to :user
  delegate :name, :to => :user
  has_and_belongs_to_many :groups
  
  named_scope :for_groups, lambda { |groups| 
    {
      :select => "DISTINCT prayers.*",
      :joins => :groups, 
      :conditions => { 
        :groups => { :id => groups.map {|g| g.id } } 
      }, 
      :order => 'updated_at DESC'
    }
  }
end
