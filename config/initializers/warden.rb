Warden::Manager.serialize_into_session do |auth|
  auth.id
end

Warden::Manager.serialize_from_session do |id|
  Auth.find_by(id: id)
end

Warden::Strategies.add(:jwt) do
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
