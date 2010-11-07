require "spec_helper"

describe NotificationMailer do
  
  let(:owner) { User.make!(:confirmed, :first_name => "Bob", :last_name => "Smith", :email => "bob@example.org") }
  let(:recipient) { User.make!(:confirmed, :first_name => "Cindy", :last_name => "Johnson", :email => "cindy@example.org" ) }
  let(:prayer) { Prayer.make!(:title => "My Prayer", :body => "Please pray for me.", :user => owner) }
  
  describe "prayer_created" do
    let(:mail) { NotificationMailer.prayer_created(recipient, prayer) }

    it_should_behave_like "any notification"

    it "has the correct subject" do
      mail.subject.should eq("New Prayer from #{owner.name}: #{prayer.title}" )
    end

    it "renders the body" do
      mail.body.encoded.should match("#{owner.name} has created a new prayer, '#{prayer.title}'.")
      mail.body.encoded.should match(prayer.body)
    end

    it "includes the link to the prayer" do
      mail.body.encoded.should match(prayer_url(prayer))
    end
  end

  describe "prayer_answered" do
    let(:mail) { NotificationMailer.prayer_answered(recipient, prayer) }
  
    it_should_behave_like "any notification"
    
    it "renders the headers" do
      mail.subject.should eq("Answered Prayer from #{owner.name}: #{prayer.title}" )
    end

    it "renders the body" do
      mail.body.encoded.should match("#{owner.name} marked the prayer, '#{prayer.title}', as answered!")
    end

    it "includes the link to the prayer" do
      mail.body.encoded.should match(prayer_url(prayer))
    end
  end
  
  describe "comment_created" do
    let(:commentor) { User.make! }
    let(:recipient) { prayer.user }
    let(:comment) { Comment.make!( :prayer => prayer, :body => "Praying for you.", :user => commentor ) }
    let(:mail) { NotificationMailer.comment_created(recipient, comment) }
    
    it_should_behave_like "any notification"
    
    it "renders the headers" do
      mail.subject.should eq("New Comment from #{commentor.name} on #{prayer.title}" )
    end

    it "renders the body" do
      mail.body.encoded.should match("#{commentor.name} commented on 'My Prayer'.")
    end

    it "includes the link to the prayer" do
      mail.body.encoded.should match(prayer_url(prayer))
    end
  end

  describe "nudge" do
    let(:recipient) { owner }
    let(:nudge) { Nudge.make!( :prayer => prayer ) }
    let(:mail) { NotificationMailer.nudge(nudge) }
    
    it_should_behave_like "any notification"
    
    it "renders the headers" do
      mail.subject.should eq("Nudge from #{nudge.user.name} on #{prayer.title}" )
    end
    
    it "renders the body" do
      mail.body.encoded.should match("#{nudge.user.name} nudged you for an update on '#{prayer.title}'.")
    end

    it "includes the link to the prayer" do
      mail.body.encoded.should match(prayer_url(prayer))
    end
  end

  describe "remind" do
    let(:mail) { NotificationMailer.remind(recipient) }

    it_should_behave_like "any notification"

    it "renders the headers" do
      mail.subject.should eq("PrayerThread Update" )
    end

    # it "renders the body" do
    #   mail.body.encoded.should match("#{owner.name} marked the prayer, '#{prayer.title}', as answered!")
    # end
  end

end
