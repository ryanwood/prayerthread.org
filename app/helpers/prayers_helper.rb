module PrayersHelper
  
  def group_list(prayer, link = true)
    groups = prayer.groups.map do |group|
      link ? link_to(group.name, group) : group.name
    end
    groups.empty? ? "no groups" : groups.join(', ')
  end
end
