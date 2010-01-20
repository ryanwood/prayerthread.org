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
      @bob = Factory(:user, :first_name => 'Bob')
      @larry = Factory(:user, :first_name => 'Larry')
      @jenny = Factory(:user, :first_name => 'Jenny')
      @sally = Factory(:user, :first_name => 'Sally')
      @group = Factory(:group, :owner => @bob)
      Factory(:membership, :group => @group, :user => @larry, :notification_level => 0)
      Factory(:membership, :group => @group, :user => @jenny, :notification_level => 2)
      Factory(:membership, :group => @group, :user => @sally, :notification_level => 2)
      @prayer = Factory(:prayer, :user => @jenny, :group_ids => [@group.id])
    end
    
    context "when a prayer is created" do
      should "send email to users in levels 1 & 2" do
        NotificationMailer.expects(:send_later).with(:deliver_prayer_created, @bob, @prayer)
        NotificationMailer.expects(:send_later).with(:deliver_prayer_created, @sally, @prayer)
        Notification.process :created, @prayer
      end

      should "not send email to user creating the prayer" do
        NotificationMailer.expects(:send_later).with(:deliver_prayer_created, @jenny, @prayer).never
        NotificationMailer.expects(:send_later).times(2)
        Notification.process :created, @prayer
      end
    
      should "not send email to those with level 0" do
        NotificationMailer.expects(:send_later).with(:deliver_prayer_created, @larry, @prayer).never
        NotificationMailer.expects(:send_later).times(2)
        Notification.process :created, @prayer
      end
    end
    
    context "when a comment is created by the owner of the prayer" do
      setup do
        @comment = Factory(:comment, :user => @jenny, :prayer => @prayer)
        NotificationMailer.expects(:send_later).with(:deliver_comment_created, @bob, @comment)
        NotificationMailer.expects(:send_later).with(:deliver_comment_created, @sally, @comment)
      end
      
      should "send email to users in levels 1 & 2" do
        Notification.process :created, @comment
      end

      should "not send email to the commentor" do
        NotificationMailer.expects(:send_later).with(:deliver_comment_created, @jenny, @comment).never
        Notification.process :created, @comment
      end
      
      should "not send email to those in level 0" do
        NotificationMailer.expects(:send_later).with(:deliver_comment_created, @larry, @comment).never
        Notification.process :created, @comment
      end
    end
    
    context "when a comment is created by someone other than the owner of the prayer" do
      setup do
        @comment = Factory(:comment, :user => @sally, :prayer => @prayer)
        NotificationMailer.expects(:send_later).with(:deliver_comment_created, @jenny, @comment)
      end
      
      should "not send email to users in level 1" do
        NotificationMailer.expects(:send_later).with(:deliver_comment_created, @bob, @comment).never
        Notification.process :created, @comment
      end

      should "send email to users in level 2" do
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