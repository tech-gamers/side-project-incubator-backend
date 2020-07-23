class SessionsController < ApplicationController
  before_action :authenticate!, except: %i[create]
  protect_from_forgery with: :exception, only: %i[create]

  def create
    send(params[:provider])
  rescue NoMethodError
    render json: {}, status: :not_implemented
  end

  def show
    render json: session.to_h
  end

  def destroy
    JwtAuth.revoke(current_auth)
    logout
    render json: {}, status: :no_content
  end

  private

  # We sign a token that will immediately expire.
  # Only use it to debug the headers.
  def developer
    unless (user = User.find_by(email: auth_hash.dig('info', 'email')))
      return render json: { error: "email not found" }, status: :not_found
    end

    token = JwtAuth.sign(user, duration: 0.seconds)
    auth = Auth.find_or_create_by!(user: user, provider: :developer)
    login(auth)
    set_cookie('jwt', token)
    render json: {}, status: :no_content
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
