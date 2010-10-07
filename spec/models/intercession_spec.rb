require 'spec_helper'

describe Intercession do
  it { should belong_to :user }
  it { should belong_to :prayer }
  it { should validate_presence_of :user }
  it { should validate_presence_of :prayer }
 
  describe '#allowed?' do
    let(:prayer) { Prayer.make! }
    let(:user) { User.make! }
    
    it "is allowed if the user has not interceded today" do
      Intercession.allowed?(user, prayer).should be_true
    end
    
    it "is not allowed if the user has already interceded today" do
      Intercession.make!(:prayer => prayer, :user => user)
      Intercession.allowed?(user, prayer).should be_false
    end
  end
end
