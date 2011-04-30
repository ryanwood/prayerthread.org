require 'spec_helper'

describe CommentObserver do

  let(:observer) { CommentObserver.instance }
  let(:comment) { Comment.make }
  
  context "after create" do
    it "fires a comment created notification" do
      Notification.should_receive(:fire).with(:created, comment)
      observer.after_create(comment)
    end
  end
  
end