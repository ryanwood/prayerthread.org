shared_examples_for "any notification" do
  it "is to the recipient" do
    mail.to.should eq([recipient.email])
  end
  it "is from prayerthread.org" do
    mail.from.should eq(["notifications@prayerthread.org"])
  end
  it "includes the link to the prayer" do
    mail.body.encoded.should match(prayer_url(prayer))
  end
end