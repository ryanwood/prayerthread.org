# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Creates paragraphs from new lines
  def p(text)
    "<p>#{text.gsub(/(\r?\n){2}/, '</p><p>')}</p>"
  end
  
end
