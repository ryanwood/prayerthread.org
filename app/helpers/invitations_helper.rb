module InvitationsHelper
  
  def format_related_users_for_autocomplete
    related = current_user.related_users.map { |u| "'#{u.first_name} #{u.last_name} &lt;#{u.email}&gt;'" }
    "var related_users = [ #{related.join(', ')} ];"
  end
  
end
