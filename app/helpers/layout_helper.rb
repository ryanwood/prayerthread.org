# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, opts = {})
    options = { :show => true, :subtitle => nil }.merge(opts)
    content_for(:title) { page_title.to_s }
    @show_title = options[:show]
    if options[:subtitle]
      content_for(:subtitle) { options[:subtitle].to_s }
      @show_subtitle = options[:show]
    end
  end
  
  def show_title?
    @show_title
  end

  def show_subtitle?
    @show_subtitle
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
