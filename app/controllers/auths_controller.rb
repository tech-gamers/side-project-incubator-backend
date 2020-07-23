class AuthsController < ApplicationController
  before_action :authenticate!, except: %i[handshake create]

  # To set CSRF header for login
  # https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html#login-csrf
  def handshake
    render json: {}, status: :no_content
  end

  def create
    if Rails.env.development?
      user = User.find(params[:user_id])
      token = JwtAuth.sign(user)
      render json: { user_id: user.id, id: Auth.for_jwt(user).id, token: token }
    else
      render json: {}, status: :forbidden
    end
  end

  def index
    @user = User.find(params[:user_id])
    render json: @user.auths, each_serializer: AuthSerializer
  end

  def destroy
    auth = Auth.find(params[:id])
    if auth.user_id == current_user.id
      if auth.id == current_auth.id
        logout
      end
      auth.destroy
      render json: {}, status: :no_content
    else
      render json: {}, status: :forbidden
    end
  end
end
