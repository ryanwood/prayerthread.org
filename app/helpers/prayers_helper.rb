module PrayersHelper
  
  def group_list(prayer, link = true)
    prayer.groups.map do |group|
      link ? link_to(group.name, group) : group.name
    end.join(", ")
  end
end
