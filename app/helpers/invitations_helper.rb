module InvitationsHelper
  
  def format_related_users_for_autocomplete(group)
    # Related users that are not in the the current group
    related = current_user.related_users - group.users
    related.map! { |u| "'#{u.first_name} #{u.last_name} &lt;#{u.email}&gt;'" }
    "var related_users = [ #{related.join(', ')} ];"
  end
  
end
