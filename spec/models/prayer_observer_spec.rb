require 'spec_helper'

describe PrayerObserver do

  let(:observer) { PrayerObserver.instance }
  let(:prayer) { Prayer.make }
  
  context "after create" do
    it "fires a comment created notification" do
      Notification.should_receive(:fire).with(:created, prayer)
      observer.after_create(prayer)
    end
  end
  
  context "after update" do
    it "fires an answered prayer notification when answered" do
      Notification.should_receive(:fire).once.with(:answered, prayer)
      observer.after_update(prayer)
      prayer.answered_at = Time.now
      observer.after_update(prayer)
    end
  end
  
end