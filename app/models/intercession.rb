class Intercession < Activity
  
  def action_text
    "prayed for"
  end
  
  def self.allowed?(user, prayer)
    # This grabs the whole list and eliminates n+1
    @intercessions_today ||= self.today
    @intercessions_today.find{ |i| i.prayer == prayer && i.user == user }.nil?
  end
  
end