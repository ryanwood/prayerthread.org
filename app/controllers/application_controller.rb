# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  # include ExceptionNotifiable
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  rescue_from CanCan::AccessDenied do
    flash[:error] = "Sorry, you can't exactly do that."
    redirect_to( root_url )
  end
  
  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = "Sorry, we couldn't find what you were looking for."
    redirect_to( :action => :index )
  end
end
