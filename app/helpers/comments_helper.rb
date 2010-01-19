module CommentsHelper
  
  def comment_class(comment)
    classes = []
    classes << "update" if comment.user == comment.prayer.user
    classes.join(' ')
  end
  
  def preview_comment(comment, length)
    more_link = link_to('more', prayer_comments_path(comment.prayer, :anchor => "comment_#{comment.id}"))
    truncate(comment.body, :length => length, :omission => "...&nbsp;more").gsub("...&nbsp;more", "...&nbsp;#{more_link}")
  end
  
end
