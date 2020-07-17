class Callbacks::OmniauthController < Devise::OmniauthCallbacksController
  def github
    @auth = Auth.from_github(request.env['omniauth.auth'])
    sign_in(@auth)
    render json: { token: '123' }
  end
end
