module Authentication
  delegate :authenticated?,
           to: :warden

  def authenticate!
    warden.authenticate!
    current_auth.track_login!(request)
  end

  def login(auth)
    # To prevent "session fixation attacks"
    # https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html#login-csrf
    reset_session
    warden.set_user(auth)
    auth.track_login!(request)
  end

  def logout
    if authenticated?
      current_auth.track_logout!(request)
      warden.logout(current_auth)
      reset_session
      cookies.clear
    end
  end

  # @return [Auth]
  def current_auth
    @current_auth ||= warden.user
  end

  # @return [User]
  def current_user
    @current_user ||= current_auth&.user
  end

  def warden
    @warden ||= request.env['warden']
  end
end
