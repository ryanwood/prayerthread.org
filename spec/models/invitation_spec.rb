require 'spec_helper'

describe Invitation, "when validated" do
  let(:group) { Group.make! }
  let(:user) { User.make! }
    
  [:recipient_email, :group].each do |attr| 
    it { should validate_presence_of(attr) }
  end
  [:sender, :group_id, :sent_at].each do |attr| 
    it { should_not allow_mass_assignment_of(attr) }
  end  

  it "does not allow duplicates for a user" do
    membership = Membership.make!(:user => user, :group => group)
    invitation = group.invitations.build( :recipient_email => user.email )
    invitation.should_not be_valid
    invitation.should have(1).error_on(:recipient_email)
    invitation.errors[:recipient_email].should include("is already a member of this group")
  end

  it "ensures no pending invitation exists" do
    existing = Invitation.make!(:recipient_email => user.email, :group => group)
    invitation = group.invitations.build(:recipient_email => user.email)
    invitation.should_not be_valid
    invitation.should have(1).error_on(:recipient_email)
    invitation.errors[:recipient_email].should include("already has a pending invitation to this group")
  end
end

describe Invitation, "after saving" do
  it "generates a token" do
    invitation = Invitation.make
    invitation.token.should be_nil
    invitation.save.should == true
    invitation.token.should_not be_nil
    invitation.token.size.should == 40
  end

  it "sends an invitation" do
    mail = double('mail')
    mail.should_receive(:deliver)
    InvitationMailer.should_receive(:invite).with(kind_of(Invitation)).and_return(mail)
    invitation = Invitation.make!
    invitation.sent_at.should be_a_kind_of(Time)
  end
end

describe Invitation, "when accepted" do
  let(:acceptor) { User.make!(:confirmed) }
  let(:invitation) { Invitation.make!(:recipient_email => acceptor.email) }
  
  before(:each) do
    Membership.should_receive(:create)
    invitation.should_not be_accepted
    invitation.accept!(acceptor)
  end
  
  it "creates a membership" do
    invitation.should be_accepted
  end
  
  it "sets accepted_at" do
    invitation.accepted_at.should be_a_kind_of(Time)
  end
end