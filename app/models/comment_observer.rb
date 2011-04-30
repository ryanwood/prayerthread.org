class CommentObserver < ActiveRecord::Observer
  
  def after_create(comment)
    Notification.fire( :created, comment )
  end
  
end