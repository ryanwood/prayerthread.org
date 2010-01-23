module InvitationsHelper
  
  def format_related_users_for_autocomplete(group)
    # Related users that are not in the the current group
    logger.debug "Loading related users"
    related = User.related(current_user, *group.users)
    related.map! { |u| "'#{u.first_name} #{u.last_name} (#{u.email})'" }
    "var related_users = [ #{related.join(', ')} ];"
  end
  
end
