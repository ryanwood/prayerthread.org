module CommentsHelper
  
  def comment_class(comment)
    classes = []
    classes << "update" if comment.user == comment.prayer.user
    classes.join(' ')
  end
  
  def show_comment(comment, length)
    if length.nil?
      simple_format(comment.body)
    else
      more_link = link_to('more', prayer_comments_path(comment.prayer, :anchor => "comment_#{comment.id}"))
      raw(truncate(comment.body, :length => length, :omission => "...&nbsp;more").gsub("...&nbsp;more", "...&nbsp;#{more_link}"))
    end
  end
  
end
