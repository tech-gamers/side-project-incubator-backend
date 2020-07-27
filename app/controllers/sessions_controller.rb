class SessionsController < ApplicationController
  before_action :authenticate!, except: %i[create]
  protect_from_forgery with: :exception, except: %i[create]

  PROVIDERS = %w[github developer].freeze

  def create
    action = params[:provider]
    if PROVIDERS.include?(action)
      send(action)
    else
      render json: {}, status: :not_implemented
    end
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

  def github
    auth = Auth.from_github(auth_hash)
    login(auth)
    redirect_to "https://tech-gamers.live/users/#{auth.user_id}"
  end

  # We sign a token that will immediately expire.
  # Only use it to debug the headers.
  def developer
    unless (user = User.find_by(email: auth_hash.dig('info', 'email')))
      return render json: { error: "email not found" }, status: :not_found
    end

    auth = Auth.find_or_create_by!(user: user, provider: :developer)
    login(auth, duration: 0.seconds)
    render json: {}, status: :no_content
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
