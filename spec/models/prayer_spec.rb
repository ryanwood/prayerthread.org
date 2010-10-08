require "spec_helper"

describe Prayer, "when validated" do
  it { should belong_to :user }
  [:title, :body, :answer, :group_ids, :praise].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end
  [:user, :prayer].each do |attr|
    it { should_not allow_mass_assignment_of(attr) }
  end
  it { should have_many(:intercessions).dependent(:destroy) }
end

describe Prayer, "when created" do
  it "populates the thread_updated_at field" do
    prayer = Prayer.make
    lambda { prayer.save }.should change(prayer, :thread_updated_at).from(nil).to(kind_of(Time))
  end
end
