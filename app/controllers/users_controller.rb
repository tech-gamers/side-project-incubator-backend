class UsersController < ApplicationController
  before_action :authenticate!

  def current
    render json: current_user, serializer: UserSerializer
  end

  def show
    if params[:id] != current_auth.user_id.to_s
      render json: {}, status: :forbidden
    else
      @user = User.find(params[:id])
      render json: @user, serializer: UserSerializer
    end
  end
end
