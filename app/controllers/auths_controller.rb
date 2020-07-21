class AuthsController < ApplicationController
  before_action :authenticate

  def index
    @user = User.find(params[:user_id])
    render json: @user.auths, each_serializer: AuthSerializer
  end

  def destroy
    @auth = Auth.find(params[:id])
    if @auth.user_id != current_auth.user_id
      render json: :forbidden
    end
    @auth.destroy!
    render status: :no_content
  end
end
