class SessionsController < Clearance::SessionsController

  def create
    cookies.delete :invitation_token
    super
  end

end
