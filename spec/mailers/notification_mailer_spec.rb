require "spec_helper"

describe NotificationMailer do
  describe "prayer_created" do
    let(:mail) { NotificationMailer.prayer_created }

    it "renders the headers" do
      mail.subject.should eq("Prayer created")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "prayer_answered" do
    let(:mail) { NotificationMailer.prayer_answered }

    it "renders the headers" do
      mail.subject.should eq("Prayer answered")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "comment_created" do
    let(:mail) { NotificationMailer.comment_created }

    it "renders the headers" do
      mail.subject.should eq("Comment created")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "nudge" do
    let(:mail) { NotificationMailer.nudge }

    it "renders the headers" do
      mail.subject.should eq("Nudge")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
