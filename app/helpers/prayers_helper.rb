module PrayersHelper

  def group_list(prayer, link = true)
    intersect = prayer.groups & current_user.groups
    groups = intersect.map do |group|
      link ? link_to(group.name, group) : group.name
    end
    groups.empty? ? "no groups" : groups.join(', ')
  end

  def prayer_title(view)
    case view
    when :praise then "Praises"
    else "#{view.to_s.humanize} Prayers"
    end
  end

  def show_detail?
    @detail == 1
  end

  def comment_type
    can?(:modify, @prayer) ? "Update" : "Comment"
  end
end
