class Comment < ActiveRecord::Base
  attr_accessible :body
  belongs_to :prayer
  belongs_to :user
  validates_presence_of :body, :on => :create, :message => "can't be blank"
  
  named_scope :recent, :order => 'created_at DESC', :limit => 5
  
  after_save :mark_thread_updated
  
  # Simply replaces new line with <p> tags
  def to_html
    out = self.body.gsub(/(\r?\n){2}/, '</p><p>')
    "<p>#{out}</p>"
  end
  
  protected
  
  def mark_thread_updated
    prayer.update_attribute :thread_updated_at, self.updated_at
  end
end
