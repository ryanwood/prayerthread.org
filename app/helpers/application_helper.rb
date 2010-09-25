module ApplicationHelper
  
  def p(text, wrap = true)
    # scrub internal text
    s = h(text)
    
    # Creates paragraphs from new lines
    s.gsub!(/(\r?\n){2}/, '</p><p>')
    s.gsub!(/(\r?\n){1}/, '<br />')
    
    raw(wrap ? "<p>#{s}</p>" : s)
  end
  
  def author(user)
    current_user == user ? "You": user.name
  end
end
