class OmniauthController < Devise::OmniauthCallbacksController
  def github
    @auth = Auth.from_github(request.env['omniauth.auth'])
    sign_in(@auth)
    redirect_to '/'
  end

  def failure
    render json: {}, status: :unauthorized
  end
end
