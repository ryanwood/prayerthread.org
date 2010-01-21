class NotificationMailer < ActionMailer::Base

  def prayer_created(recipient, prayer)
    subject     "New Prayer from #{prayer.user.name}"
    recipients  recipient.full_email
    from        DO_NOT_REPLY
    sent_on     Time.now
    body        :recipient => recipient,
                :prayer => prayer
  end

  def comment_created(recipient, comment)
    activity = (comment.user == comment.prayer.user) ? "Update" : "Comment"
    subject     "New #{activity} from #{comment.name} on #{truncate(comment.prayer.title, :length => 40)}"
    recipients  recipient.full_email
    from        DO_NOT_REPLY
    sent_on     Time.now
    body        :recipient => recipient,
                :prayer => comment.prayer,
                :comment => comment,
                :activity => activity
  end

end
