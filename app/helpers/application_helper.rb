# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Creates paragraphs from new lines
  def p(text, wrap = true)
    s = text.gsub(/(\r?\n){2}/, '</p><p>')
    s = s.gsub(/(\r?\n){1}/, '<br />')
    wrap ? "<p>#{s}</p>" : s
  end
  
  def author(user)
    current_user == user ? "You": user.name
  end
  
end
