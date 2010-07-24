class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  before_filter :ensure_domain
  include Clearance::Authentication
  
  # include ExceptionNotifiable
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  rescue_from CanCan::AccessDenied do
    render :template => "/shared/no_access"
  end
  
  # rescue_from ActiveRecord::RecordNotFound do
  #   flash[:error] = "Sorry, we couldn't find what you were looking for."
  #   redirect_to( :action => :index )
  # end

  def ensure_domain
    if RAILS_ENV == 'production' && request.env['HTTP_HOST'] != HOST
      redirect_to "http://#{HOST}"
    end
  end
end
