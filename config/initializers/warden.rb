Warden::Manager.serialize_into_session do |auth|
  auth.id
end

Warden::Manager.serialize_from_session do |id|
  Auth.find_by(id: id)
end

Warden::Strategies.add(:jwt) do
  def valid?
    request.cookies['jwt'].present?
  end

  def authenticate!
    case (auth_or_error = JwtAuth.authenticate_auth(request.cookies['jwt']))
    when Auth
      success!(auth_or_error)
    else
      fail!(auth_or_error)
    end
  end
end
