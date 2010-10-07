require 'spec_helper'

describe Nudge do
  it { should belong_to :user }
  it { should belong_to :prayer }
  it { should validate_presence_of :user }
  it { should validate_presence_of :prayer }
 
  describe '#allowed?' do
    let(:prayer) { Prayer.make! }
    let(:user) { User.make! }
    
    it "is allowed if the user has not interceded today" do
      Nudge.allowed?(user, prayer).should be_true
    end

    it "is allowed if it has been more than week" do
      Intercession.make!(:prayer => prayer, :user => user, :created_at => 2.week.ago)
      Intercession.allowed?(user, prayer).should be_true
    end
    
    it "is not allowed if the user has already nudged this week" do
      Nudge.make!(:prayer => prayer, :user => user, :created_at => 6.days.ago)
      Nudge.allowed?(user, prayer).should be_false
    end
  end
end
