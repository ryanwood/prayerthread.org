class NotificationMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  default :from => "notifications@prayerthread.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification.prayer_created.subject
  #
  def prayer_created(recipient, prayer)
    @recipient = recipient
    @prayer = prayer

    mail( :to => recipient.full_email,
          :subject => "New Prayer from #{prayer.user.name}: #{truncate(prayer.title, :length => 40)}" )
  end

  def prayer_answered(recipient, prayer)
    @recipient = recipient
    @prayer = prayer

    mail( :to => recipient.full_email,
          :subject => "Answered Prayer from #{prayer.user.name}: #{truncate(prayer.title, :length => 40)}" )
  end

  def comment_created(recipient, comment)
    @recipient = recipient
    @prayer = comment.prayer
    @comment = comment
    @activity = (comment.user == comment.prayer.user) ? "Update" : "Comment"

    mail( :to => recipient.full_email,
          :subject => "New #{activity} from #{comment.user.name} on #{truncate(comment.prayer.title, :length => 40)}" )
  end

  def nudge(nudge)
    @recipient = nudge.prayer.user
    @nudge = nudge

    mail( :to => recipient.full_email,
          :subject => "Nudge from #{nudge.user.name} on #{truncate(nudge.prayer.title, :length => 40)}" )
  end
end