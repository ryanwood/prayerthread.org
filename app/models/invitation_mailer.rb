class InvitationMailer < ActionMailer::Base
  
  default_url_options[:host] = APP_CONFIG[:domain]

  def invitation(invitation)
    from       APP_CONFIG[:do_not_reply]
    recipients invitation.recipient_email
    subject    "Prayer Group Invitation"
    body       :invitation => invitation
  end

end
