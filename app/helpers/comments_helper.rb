module CommentsHelper
  
  def comment_class(comment)
    classes = []
    classes << "update" if comment.user == comment.prayer.user
    classes.join(' ')
  end
  
end
