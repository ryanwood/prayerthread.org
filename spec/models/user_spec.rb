require "spec_helper"

describe User do
  let(:user) { User.make(:confirmed) }

  it "has a name" do
    user.name.should == "#{user.first_name} #{user.last_name}"
  end
  
  it "has a full email with name" do
    user.full_email.should == "#{user.first_name} #{user.last_name} <#{user.email}>"   
  end
end

describe User, "when validated" do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should allow_mass_assignment_of :first_name }
  it { should allow_mass_assignment_of :last_name }
  it { should allow_mass_assignment_of :invitation_token }
  [:prayers, :memberships, :invitations, :sent_invitations, :comments, :owned_groups].each do |attr|
    it { should have_many(attr) } 
  end
  it { should have_many(:groups).through(:memberships) }
end

# should "accept the first invitation when confirming an email" do
#   user = Factory(:user)
#   invite = Factory(:invitation, :recipient_id => user.id)
#   assert !user.invitations.first.accepted?
#   user.confirm_email!
#   assert user.invitations.first.accepted?
# end

    
describe User, "when created" do
  let(:invitation) { Invitation.make! } 
  let(:user) { User.make } 

  context "with an invalid token" do
    it "does not associate an invitation to the user" do
      user.invitation_token = 'BADTOKEN'
      user.invitations.should_not_receive(:<<)
      user.save
    end
  end

  context "with a valid token" do
    it "associates the invitation to the user" do
      user.invitation_token = invitation.token
      user.invitations.should_receive(:<<).with(invitation)
      user.save
    end
  end
end
