# require 'spec_helper'
# 
# describe Notification, "events" do
#   
#   it "knows it's invokeable events" do
#     Notification::EVENTS.should be_a_kind_of( Array )
#   end
#   
#   it "throws an error for an unknown event" do
#     Notification::EVENTS.should_not include(:bogus)
#     lambda { Notification.new(:bogus, Prayer.make) }.should raise_error(ArgumentError)
#   end
#   
#   it "throws an error if a model doesn't support an event" do
#     lambda { 
#       Notification.new(:answered, Comment.new).perform
#     }.should raise_error(ArgumentError)
#   end
#   
# end
# 
# describe Notification, "for" do
#   [:user1, :user0, :user2a, :user2b].each do |user|
#     let(user) { User.make!(:confirmed) }
#   end
#   let(:group) { Group.make!(:owner => user1 )}
#   
#   
#   before(:each) do
#     # need to update User 1's membership since it's auto-created
#     user1.memberships.first.update_attribute :notification_level, 1
#     
#     Factory(:membership, :group => @group, :user => @larry, :notification_level => 0)
#     Factory(:membership, :group => @group, :user => @jenny, :notification_level => 2)
#     Factory(:membership, :group => @group, :user => @sally, :notification_level => 2)
#     
#     @prayer = Factory(:prayer, :user => @jenny, :group_ids => [@group.id])
#   end
# end
  
  
  
  
  
  
#   
#   context "a new prayer" do
#     setup do
#       @notification = Notification.new(:created, @prayer)
#     end
#     
#     should "notify levels 1 & 2" do
#       NotificationMailer.expects(:deliver_prayer_created).with(u("Bob"), @prayer)
#       NotificationMailer.expects(:deliver_prayer_created).with(u("Sally"), @prayer)
#       @notification.perform
#     end
#     
#     should "not notify the creator" do
#       NotificationMailer.expects(:deliver_prayer_created).with(u("Jenny"), @prayer).never
#       NotificationMailer.expects(:deliver_prayer_created).times(2)
#       @notification.perform
#     end
#         
#     should "not notify level 0" do
#       NotificationMailer.expects(:deliver_prayer_created).with(u("Larry"), @prayer).never
#       NotificationMailer.expects(:deliver_prayer_created).times(2)
#       @notification.perform
#     end
#   end
#   
#   context "a new comment" do
#   
#     context "by the prayer owner" do
#       setup do
#         @comment = Factory(:comment, :user => @jenny, :prayer => @prayer)
#         NotificationMailer.expects(:deliver_comment_created).with(u("Bob"), @comment)
#         NotificationMailer.expects(:deliver_comment_created).with(u("Sally"), @comment)
#         @notification = Notification.new(:created, @comment)
#       end
#             
#       should "notify level 1 & 2" do
#         @notification.perform
#       end
#   
#       should "not notify the commentor" do
#         NotificationMailer.expects(:deliver_comment_created).with(u("Jenny"), @comment).never
#         @notification.perform
#       end
#     
#       should "not notify level 0" do
#         NotificationMailer.expects(:deliver_comment_created).with(u("Larry"), @comment).never
#         @notification.perform
#       end
#     end
#     
#     context "by someone other than the prayer owner" do
#       setup do
#         @comment = Factory(:comment, :user => @sally, :prayer => @prayer)
#         NotificationMailer.expects(:deliver_comment_created).with(u("Jenny"), @comment)
#         @notification = Notification.new(:created, @comment)
#       end
#     
#       should "not notify level 1" do
#         NotificationMailer.expects(:deliver_comment_created).with(u("Bob"), @comment).never
#         @notification.perform
#       end
#   
#       should "notify level 2 if the notifyee owns the prayer" do
#         # Need a level 2 user that doesn't own the prayer
#         @roger = Factory(:user, :first_name => 'Roger')   # => level 2
#         Factory(:membership, :group => @group, :user => @roger, :notification_level => 2)
#         #NotificationMailer.expects(:deliver_comment_created).with(u("Roger"), @comment).never
#         @notification.perform
#       end
#     
#       should "not send email to the commentor" do
#         NotificationMailer.expects(:deliver_comment_created).with(u("Sally"), @comment).never
#         @notification.perform
#       end
#     
#       should "not send email to those in level 0" do
#         NotificationMailer.expects(:deliver_comment_created).with(u("Larry"), @comment).never
#         @notification.perform
#       end
#     end
#   end
# end
# 
# # Create a user that is readable in the test results.
# # Shows the name rather than #<User:0x444b980>
# def u(name)
#   responds_with(:first_name, name)
# end