class SessionsController < ApplicationController
  before_action :authenticate!, except: %i[create]

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

  def developer
    render json: {
      "provider": "developer",
      "uid": "demo@demo.com",
      "info": {
        "name": "demo",
        "email": "demo@demo.com"
      },
      "credentials": {
        "token": nil,
        "secret": nil
      },
      "extra": {}
    }
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
