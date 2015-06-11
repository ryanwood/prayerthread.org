class InvitationMailer < ActionMailer::Base
  default :from => Settings.mail.from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.invite.subject
  #
  def invite(invitation)
    @invitation = invitation

    mail( :to => invitation.recipient_email,
          :subject => "Prayer Group Invitation" )
  end
end
