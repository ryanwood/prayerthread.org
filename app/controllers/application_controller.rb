class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  # before_filter :ensure_domain
  include Clearance::Authentication
  
  # include ExceptionNotifiable
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  rescue_from CanCan::AccessDenied do |e|
    logger.warn { "ACCESS DENIED: User #{current_user.name} (#{current_user.id}) was denied #{e.action.to_s.upcase} access to #{e.subject.class} (#{e.subject.try(:id)})" }
    logger.debug{ e.subject.inspect }
    render :template => "/shared/no_access"
  end
  
  # rescue_from ActiveRecord::RecordNotFound do
  #   flash[:error] = "Sorry, we couldn't find what you were looking for."
  #   redirect_to( :action => :index )
  # end

  # def ensure_domain
  #   if Rails.env.production? && request.env['HTTP_HOST'] != HOST
  #     redirect_to "http://#{HOST}"
  #   end
  # end
end
