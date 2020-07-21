class OmniauthController < Devise::OmniauthCallbacksController
  def github
    @auth = Auth.from_github(request.env['omniauth.auth'])
    sign_in(@auth)
    redirect_to "https://alpha.tech-gamers.live/users/#{@auth.user_id}"
  end

  def failure
    render json: {}, status: :unauthorized
  end
end
