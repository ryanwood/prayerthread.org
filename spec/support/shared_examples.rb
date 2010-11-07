shared_examples_for "any notification" do
  it "is to the recipient" do
    mail.to.should eq([recipient.email])
  end

  it "is from prayerthread.org" do
    mail.from.should eq(["donotreply@prayerthread.org"])
  end

  it "includes an intro" do
    mail.body.encoded.should match(/Hi #{recipient.first_name},/)
  end

  it "can be sent" do
    mail.deliver
    ActionMailer::Base.deliveries.should_not be_empty
  end

  it "includes the footer" do
    mail.body.encoded.should match(/This message sent from PrayerThread./)
    mail.body.encoded.should match(/Manage your email preferences/)
    mail.body.encoded.should match(/- DO NOT REPLY TO THIS EMAIL -/)
  end
end