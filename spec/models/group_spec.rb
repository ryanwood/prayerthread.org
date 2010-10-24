require 'spec_helper'

describe Group do
  [:name, :owner_id, :description].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end
  it { should belong_to(:owner) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:users).through(:memberships) }
  it { should have_many(:invitations) }
  it { should have_and_belong_to_many(:prayers) }

  [:name, :owner].each do |attr|
    it { should validate_presence_of(attr) }
  end

  context "after create" do
    it "ensures that the owner is a member" do
      group = Group.make
      group.should have(0).memberships
      group.save.should == true
      group.should have(1).membership
    end
  end
end
