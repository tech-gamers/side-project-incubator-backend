Warden::Strategies.add(:jwt) do
  # TODO: https://devise-token-auth.gitbook.io/devise-token-auth/usage/controller_methods#token-header-format
  def valid?
    params['token'].present?
  end

  def authenticate!
    case (auth_or_error = JwtAuth.authenticate_auth(params['token']))
    when Auth
      success!(auth_or_error)
    else
      fail!(auth_or_error)
    end
  end
end
