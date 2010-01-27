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
  
  context "Notifications" do
    setup do
      @bob = Factory(:user, :first_name => 'Bob')       # => level 1
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
    
    context "A new prayer" do
      should "notify levels 1 & 2" do
        NotificationMailer.expects(:send_later).with(:deliver_prayer_created, @bob, @prayer)
        NotificationMailer.expects(:send_later).with(:deliver_prayer_created, @sally, @prayer)
        Notification.process :created, @prayer
      end

      should "not notify the creator" do
        NotificationMailer.expects(:send_later).with(:deliver_prayer_created, @jenny, @prayer).never
        NotificationMailer.expects(:send_later).times(2)
        Notification.process :created, @prayer
      end
    
      should "not notify level 0" do
        NotificationMailer.expects(:send_later).with(:deliver_prayer_created, @larry, @prayer).never
        NotificationMailer.expects(:send_later).times(2)
        Notification.process :created, @prayer
      end
    end
    
    context "A new comment" do
    
      context "by the prayer owner" do
        setup do
          @comment = Factory(:comment, :user => @jenny, :prayer => @prayer)
          NotificationMailer.expects(:send_later).with(:deliver_comment_created, @bob, @comment)
          NotificationMailer.expects(:send_later).with(:deliver_comment_created, @sally, @comment)
        end
      
        should "notify level 1 & 2" do
          Notification.process :created, @comment
        end

        should "not notify the commentor" do
          NotificationMailer.expects(:send_later).with(:deliver_comment_created, @jenny, @comment).never
          Notification.process :created, @comment
        end
      
        should "not notify level 0" do
          NotificationMailer.expects(:send_later).with(:deliver_comment_created, @larry, @comment).never
          Notification.process :created, @comment
        end
      end
      
      context "by someone other than the prayer owner" do
        setup do
          @comment = Factory(:comment, :user => @sally, :prayer => @prayer)
          NotificationMailer.expects(:send_later).with(:deliver_comment_created, @jenny, @comment)
        end
      
        should "not notify level 1" do
          NotificationMailer.expects(:send_later).with(:deliver_comment_created, @bob, @comment).never
          Notification.process :created, @comment
        end

        should "notify level 2 if the notifyee owns the prayer" do
          # Need a level 2 user that doesn't own the prayer
          @roger = Factory(:user, :first_name => 'Roger')   # => level 2
          Factory(:membership, :group => @group, :user => @roger, :notification_level => 2)
          #NotificationMailer.expects(:send_later).with(:deliver_comment_created, @roger, @comment).never
          Notification.process :created, @comment
        end
      
        should "not send email to the commentor" do
          NotificationMailer.expects(:send_later).with(:deliver_comment_created, @sally, @comment).never
          Notification.process :created, @comment
        end
      
        should "not send email to those in level 0" do
          NotificationMailer.expects(:send_later).with(:deliver_comment_created, @larry, @comment).never
          Notification.process :created, @comment
        end
      end
    end
  end
  
  
end