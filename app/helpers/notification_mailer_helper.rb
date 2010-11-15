module NotificationMailerHelper

  def prayer_snippet(prayer, field, length = 200)
    snippet(
      prayer.send(field),
      link_to(more_text, prayer_url( prayer), link_style_hash),
      length
    )
  end

  def comment_snippet(comment, length = 200)
    snippet(
      comment.body,
      link_to(more_text, prayer_url( comment.prayer, :anchor => "comment_#{comment.id}"), link_style_hash),
      length
    )
  end

  def snippet(text, omission, length = 200)
    # text.match(/(.{200}.*?\n)/m)
    raw( truncate( h( text ), :length => 200, :omission => omission) )
  end

  def more_text
    ' ... continue reading'
  end

  def link_style_hash
    { :style => "color: #00275E;" }
  end

end