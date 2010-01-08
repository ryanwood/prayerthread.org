class InvitationMailer < ActionMailer::Base
  
  default_url_options[:host] = HOST

  def invitation(invitation)
    from       DO_NOT_REPLY
    recipients invitation.recipient_email
    subject    "Prayer Group Invitation"
    body       :invitation => invitation
  end

end
