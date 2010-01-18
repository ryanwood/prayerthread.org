class NotificationMailer < ActionMailer::Base

  def prayer_notification(recipient, prayer)
    subject     "New Prayer from #{prayer.user.name}"
    recipients  recipient.full_email
    from        DO_NOT_REPLY
    sent_on     Time.now
    logger.debug "*** In NotificationMailer: #{prayer.to_param}"
    body        :recipient => recipient,
                :prayer => prayer
  end

  def comment_notification(sent_at = Time.now)
    subject    'NotificationMailer#comment'
    recipients ''
    from       DO_NOT_REPLY
    sent_on    Time.now
    
    body       :greeting => 'Hi,'
  end

end
