require "spec_helper"

describe InvitationMailer do
  describe "invite" do
    let(:group) { Group.make! }
    let(:invite) { Invitation.make! }
    let(:mail) { InvitationMailer.invite(invite) }

    it "renders the headers" do
      mail.subject.should eq("Prayer Group Invitation")
      mail.to.should eq([invite.recipient_email])
      mail.from.should eq(["donotreply@prayerthread.org"])
    end

    it "renders the body" do
      mail.body.encoded.should match("You've been invited by #{invite.sender.name} to join the #{invite.group.name} prayer group.")
    end
  end

end
