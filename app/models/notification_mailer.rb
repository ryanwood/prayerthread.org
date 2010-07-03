require 'action_pack'
class NotificationMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  def prayer_created(recipient, prayer)
    subject     "New Prayer from #{prayer.user.name}: #{truncate(prayer.title, :length => 40)}"
    recipients  recipient.full_email
    from        DO_NOT_REPLY
    sent_on     Time.now
    body        :recipient => recipient,
                :prayer => prayer
  end
  
  def prayer_answered(recipient, prayer)
    subject     "Answered Prayer from #{prayer.user.name}: #{truncate(prayer.title, :length => 40)}"
    recipients  recipient.full_email
    from        DO_NOT_REPLY
    sent_on     Time.now
    body        :recipient => recipient,
                :prayer => prayer
  end  

  def comment_created(recipient, comment)
    activity = (comment.user == comment.prayer.user) ? "Update" : "Comment"
    subject     "New #{activity} from #{comment.user.name} on #{truncate(comment.prayer.title, :length => 40)}"
    recipients  recipient.full_email
    from        DO_NOT_REPLY
    sent_on     Time.now
    body        :recipient => recipient,
                :prayer => comment.prayer,
                :comment => comment,
                :activity => activity
  end
  
  def nudge(nudge)
    subject     "Nudge from #{nudge.user.name} on #{truncate(nudge.prayer.title, :length => 40)}"
    recipients  nudge.prayer.user.full_email
    from        DO_NOT_REPLY
    sent_on     Time.now
    body        :recipient => nudge.prayer.user,
                :nudge => nudge
  end
end
