module Authentication
  delegate :authenticate!,
           :authenticated?,
           to: :warden

  def login(user)
    auth = Auth.for_jwt(user)
    warden.set_user(auth)
    auth.track_login!(request)
  end

  def logout
    if authenticated?
      current_auth.track_logout!
      warden.logout(current_auth)
    end
  end

  def current_auth
    @current_auth ||= warden.user
  end

  def current_user
    @current_user ||= current_auth&.user
  end

  def warden
    @warden ||= request.env['warden']
  end
end
