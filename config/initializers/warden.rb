Warden::Manager.serialize_into_session do |auth|
  auth.id
end

Warden::Manager.serialize_from_session do |id|
  Auth.find_by(id: id)
end

Warden::Strategies.add(:jwt) do
  def valid?
    jwt_token.present?
  end

  def authenticate!
    case (auth_or_error = JwtAuth.authenticate_auth(jwt_token))
    when Auth
      success!(auth_or_error)
    else
      fail!(auth_or_error)
    end
  end

  PATTERN = /^Bearer (?<token>.*)/.freeze
  def jwt_token
    header = env['HTTP_AUTHORIZATION']
    if (match = PATTERN.match(header))
      match[:token]
    end
  end
end
