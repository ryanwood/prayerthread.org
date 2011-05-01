module ApplicationHelper
  def author(user)
    current_user == user ? "You": user.name
  end
  
  def current_announcements
    unless session[:announcement_hide_time].nil?
      time = session[:announcement_hide_time]
    else
      time = cookies[:announcement_hide_time].to_datetime unless cookies[:announcement_hide_time].nil?
    end
    @current_announcements ||= Announcement.current_announcements(time)
  end
end
