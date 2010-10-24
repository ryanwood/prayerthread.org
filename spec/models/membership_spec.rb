require 'spec_helper'

describe Membership, "when validated" do
  # An existing record is needed for the uniqueness validation
  before(:each) { Membership.make! }
  
  [:user, :group].each do |attr|
    it { should belong_to(attr) }
    it { should validate_presence_of(attr) }
    it { should allow_mass_assignment_of(attr) }
  end

  it { should allow_mass_assignment_of(:notification_level) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:group_id) }
end

describe Membership, "when created" do
  it "sets the default notification level to 2" do
    membership = Membership.make!(:notification_level => nil)
    membership.notification_level.should == 2
  end
end