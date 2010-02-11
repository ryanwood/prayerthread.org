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
    when :praise : "Praises"
    else "#{view.to_s.humanize} Prayers"
    end
  end
  
  def view_links(current_view)
    views = [ :all, :open, :answered, :praise ]
    capture_haml do
      haml_tag :ul, :class => "views links" do
        views.each do |view|
          haml_tag(:li, :class => ('selected' if view == current_view)) do
            haml_tag(:a, prayer_title(view), :href => prayers_path( :view => view.to_s ))
          end
        end
      end
    end
  end
  
end
