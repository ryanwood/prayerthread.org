require "spec_helper"

describe Prayer do
  it { should belong_to :user }
  [:title, :body, :answer, :group_ids, :praise].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end
  [:user, :prayer].each do |attr|
    it { should_not allow_mass_assignment_of(attr) }
  end
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:updates) }
  it { should have_many(:audience_comments) }
  it { should have_many(:activities).dependent(:destroy) }
  it { should have_many(:intercessions).dependent(:destroy) }
  it { should have_many(:nudges).dependent(:destroy) }

  it { should have_and_belong_to_many(:groups) }

  it "has intercessors" do
    prayer = Prayer.make!
    user = User.make!
    Intercession.make!(:prayer => prayer, :user => user)
    prayer.should have(1).intercessor
    prayer.intercessors.first.should == user
  end
end

describe Prayer, "when created" do
  it "populates the thread_updated_at field" do
    prayer = Prayer.make
    lambda { prayer.save }.should change(prayer, :thread_updated_at).from(nil).to(kind_of(Time))
  end
end
