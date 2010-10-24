require "spec_helper"

describe Event do
  let(:originator) { User.make! } 
  let(:prayer) { Prayer.make!(:user => originator) }
  
  it "has known event conditions" do
    Event::TYPES.should be_an(Array) 
  end

  it "has known event mappings" do
    Event::MAP.should be_a(Hash) 
  end

  it "raises an error for an unknown condition" do
    Event::TYPES.should_not include(:unknown)
    lambda { Event.new(:unknown, prayer) }.should raise_error(ArgumentError)
  end

  it "raises an error for an event mismatch" do
    Event::TYPES.should include(:answered)
    lambda { Event.new(:answered, Comment.make) }.should raise_error(ArgumentError)
  end

  context "on prayer created" do
    let(:event) { Event.new(:created, prayer) }

    it "has an event type of :created" do
      event.type.should == :created
    end

    it "has a condition of 'prayer_created'" do
      event.condition.should == 'prayer_created'
    end

    it "has a prayer" do
      event.prayer.should == prayer
    end

    it "filters the prayer owner" do
      event.filtered_users.should include(prayer.user)
    end

    it "uses the mailer 'prayer_created'" do
      event.mailer.should == :prayer_created
    end
  end
  
  context "on prayer answered" do
    let(:event) { Event.new(:answered, prayer) }
    
    it "has an event type of :answered" do
      event.type.should == :answered
    end

    it "has a condition of 'prayer_answered'" do
      event.condition.should == 'prayer_answered'
    end

    it "has a prayer" do
      event.prayer.should == prayer
    end

    it "filters the prayer owner" do
      event.filtered_users.should include(prayer.user)
    end

    it "uses the mailer 'prayer_answered'" do
      event.mailer.should == :prayer_answered
    end
  end

  context "on comment created by someone other than the prayer owner" do
    let(:comment) { Comment.make(:prayer => prayer) }
    let(:event) { Event.new(:created, comment) }
    
    it "has an event type of :created" do
      event.type.should == :created
    end

    it "has a condition of 'comment_to_originator'" do
      event.condition.should == 'comment_to_originator'
    end

    it "has a prayer" do
      event.prayer.should == prayer
    end

    it "filters the comment owner" do
      event.filtered_users.should include(comment.user)
    end

    it "uses the mailer 'comment_created'" do
      event.mailer.should == :comment_created
    end
  end
  
  context "on comment created by the prayer owner" do
    let(:comment) { Comment.make(:prayer => prayer, :user => prayer.user) }
    let(:event) { Event.new(:created, comment) }
    
    it "has an event type of :created" do
      event.type.should == :created
    end
    
    it "has a condition of 'comment_from_originator'" do
      event.condition.should == 'comment_from_originator'
    end

    it "has a prayer" do
      event.prayer.should == prayer
    end

    it "filters the comment owner" do
      event.filtered_users.should include(comment.user)
    end

    it "uses the mailer 'comment_created'" do
      event.mailer.should == :comment_created
    end
  end

  context "when building an audience" do
    let(:group1) { Group.make! }
    let(:group2) { Group.make! }
    let(:user1) { User.make!(:confirmed) }
    let(:user2) { User.make!(:confirmed) }
    let(:membership1) { Membership.make!(:group => group1, :user => user1) }
    let(:membership2) { Membership.make!(:group => group2, :user => user2) }

    it "includes users in associated groups with the notification turned on" do
      prayer.groups << group1
      membership1.update_attribute :notification_level, 2 
      membership1.update_attribute :notify_on_prayer_created, true
      event = Event.new(:created, prayer) 
      event.audience.should include(user1)
      event.audience.should_not include(user2)
    end
    
    it "skips users in associated group with the notification turned off" do
      prayer.groups << group1
      membership1.update_attribute :notification_level, 0 
      membership1.notify_on_prayer_created.should == false
      event = Event.new(:created, prayer) 
      event.audience.should_not include(user1)
      event.audience.should_not include(user2)
    end

    it "contains only the prayer user on comment from group member" do
      Membership.make!(:group => group1, :user => originator)

      group1.should have(2).memberships
      group2.should have(1).membership
      
      prayer.groups = [group1, group2]
      prayer.should have(2).groups

      comment = Comment.make!(:prayer => prayer, :user => user1)
      event = Event.new(:created, comment) 
      
      event.condition.should == 'comment_to_originator'
      event.audience.should have(1).item
      event.audience.should_not include(user1)
      event.audience.should_not include(user2)
      event.audience.should include(originator)
    end 

    it "should filter out the source user" do
      Membership.make!(:group => group1, :user => originator)
      prayer.groups << group1
      event = Event.new(:created, prayer) 
      event.audience.should have(1).item
      event.audience.should_not include(originator)
    end
  end
end
