class PrayerObserver < ActiveRecord::Observer
  
  def after_create(prayer)
    Notification.fire( :created, prayer )
  end
  
  def after_update(prayer)
    if prayer.answered_at_changed? && prayer.answered?
      Notification.fire(:answered, prayer)
    end
  end
  
end