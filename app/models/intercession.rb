class Intercession < Activity
  
  def action_text
    "prayed for"
  end
  
  def self.allowed?(user, prayer)
    today.find{ |i| i.prayer == prayer && i.user == user }.nil?
  end
  
end