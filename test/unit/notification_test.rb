require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  
  should "have an EVENTS constant" do
    assert Notification::EVENTS.kind_of? Array
  end
  
  should "throw an error for a unknown event" do
    assert !Notification::EVENTS.include?(:bogus)
    assert_raise(ArgumentError) {
      n = Notification.new(:bogus, Factory.build(:prayer))
    }
  end
  
  should "throw an error if an invalid event is passed in" do
    assert_raise(ArgumentError) { Notification.new(:some_bogus_event, Prayer.new) }
  end
  
  should "throw an error if a model doesn't support an event" do
    assert_raise(ArgumentError) { 
      n = Notification.new(:answered, Comment.new) 
      n.perform
    }
  end
  
  context "Notification for" do
    setup do
      @bob   = Factory(:user, :first_name => 'Bob')     # => level 1
      @larry = Factory(:user, :first_name => 'Larry')   # => level 0
      @jenny = Factory(:user, :first_name => 'Jenny')   # => level 2
      @sally = Factory(:user, :first_name => 'Sally')   # => level 2
      
      @group = Factory(:group, :owner => @bob)
      
      # need to update Bob's membership since it's auto-created
      @bob.memberships.first.update_attribute :notification_level, 1
      
      Factory(:membership, :group => @group, :user => @larry, :notification_level => 0)
      Factory(:membership, :group => @group, :user => @jenny, :notification_level => 2)
      Factory(:membership, :group => @group, :user => @sally, :notification_level => 2)
      
      @prayer = Factory(:prayer, :user => @jenny, :group_ids => [@group.id])
    end
    
    context "a new prayer" do
      setup do
        @notification = Notification.new(:created, @prayer)
      end
      
      should "notify levels 1 & 2" do
        NotificationMailer.expects(:deliver_prayer_created).with(u("Bob"), @prayer)
        NotificationMailer.expects(:deliver_prayer_created).with(u("Sally"), @prayer)
        @notification.perform
      end
      
      should "not notify the creator" do
        NotificationMailer.expects(:deliver_prayer_created).with(u("Jenny"), @prayer).never
        NotificationMailer.expects(:deliver_prayer_created).times(2)
        @notification.perform
      end
          
      should "not notify level 0" do
        NotificationMailer.expects(:deliver_prayer_created).with(u("Larry"), @prayer).never
        NotificationMailer.expects(:deliver_prayer_created).times(2)
        @notification.perform
      end
    end
    
    context "a new comment" do
    
      context "by the prayer owner" do
        setup do
          @comment = Factory(:comment, :user => @jenny, :prayer => @prayer)
          NotificationMailer.expects(:deliver_comment_created).with(u("Bob"), @comment)
          NotificationMailer.expects(:deliver_comment_created).with(u("Sally"), @comment)
          @notification = Notification.new(:created, @comment)
        end
              
        should "notify level 1 & 2" do
          @notification.perform
        end
    
        should "not notify the commentor" do
          NotificationMailer.expects(:deliver_comment_created).with(u("Jenny"), @comment).never
          @notification.perform
        end
      
        should "not notify level 0" do
          NotificationMailer.expects(:deliver_comment_created).with(u("Larry"), @comment).never
          @notification.perform
        end
      end
      
      context "by someone other than the prayer owner" do
        setup do
          @comment = Factory(:comment, :user => @sally, :prayer => @prayer)
          NotificationMailer.expects(:deliver_comment_created).with(u("Jenny"), @comment)
          @notification = Notification.new(:created, @comment)
        end
      
        should "not notify level 1" do
          NotificationMailer.expects(:deliver_comment_created).with(u("Bob"), @comment).never
          @notification.perform
        end
    
        should "notify level 2 if the notifyee owns the prayer" do
          # Need a level 2 user that doesn't own the prayer
          @roger = Factory(:user, :first_name => 'Roger')   # => level 2
          Factory(:membership, :group => @group, :user => @roger, :notification_level => 2)
          #NotificationMailer.expects(:deliver_comment_created).with(u("Roger"), @comment).never
          @notification.perform
        end
      
        should "not send email to the commentor" do
          NotificationMailer.expects(:deliver_comment_created).with(u("Sally"), @comment).never
          @notification.perform
        end
      
        should "not send email to those in level 0" do
          NotificationMailer.expects(:deliver_comment_created).with(u("Larry"), @comment).never
          @notification.perform
        end
      end
    end
  end
  
  # Create a user that is readable in the test results.
  # Shows the name rather than #<User:0x444b980>
  def u(name)
    responds_with(:first_name, name)
  end
  
  
end