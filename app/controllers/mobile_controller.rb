class MobileController < ApplicationController
  
  def force_mobile_view
    session[:mobile_view] = true
    redirect_to root_path
  end
  
  def force_standard_view
    session[:mobile_view] = false
    redirect_to root_path
  end
  
end
