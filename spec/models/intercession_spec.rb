require 'spec_helper'

describe Intercession do
  it { should belong_to :user }
  it { should belong_to :prayer }
  it { should validate_presence_of :user }
  it { should validate_presence_of :prayer }
 
  describe '#allowed?' do
    let(:prayer) { Prayer.make! }
    let(:user) { User.make! }
    
    it "is allowed if the user has not interceded" do
      prayer.should have(0).intercessions
      Intercession.allowed?(user, prayer).should be_true
    end
    
    it "is allowed if it has been more than one day" do
      Intercession.make!(:prayer => prayer, :user => user, :created_at => 1.day.ago)
      Intercession.allowed?(user, prayer).should be_true
    end
    
    it "is not allowed if the user has already interceded today" do
      Intercession.make!(:prayer => prayer, :user => user)
      Intercession.allowed?(user, prayer).should be_false
    end
  end
end
