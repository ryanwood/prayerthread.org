module PrayersHelper
  
  def group_list(prayer, link = true)
    intersect = prayer.groups & current_user.groups
    groups = intersect.map do |group|
      link ? link_to(group.name, group) : group.name
    end
    groups.empty? ? "no groups" : groups.join(', ')
  end
  
end
