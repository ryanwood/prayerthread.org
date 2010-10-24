require 'spec_helper'

describe Comment do
  it { should belong_to :prayer }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should_not allow_mass_assignment_of :prayer_id }
  it { should_not allow_mass_assignment_of :user_id }

  it "marks the thread as updated when saved" do
    prayer = Prayer.make
    prayer.should_receive(:update_attribute).with(:thread_updated_at, kind_of(Time))
    comment = Comment.make!(:prayer => prayer)
  end

  it "creates an intercession on create if asked" do
    Intercession.should_receive(:create).once
    Comment.make! :intercede => '0'
    Comment.make! :intercede => '1'
  end

end
