class UsersController < ApplicationController
  before_action :authenticate_auth!

  def show
    @user = User.find(params[:id])
    if @user.id != current_auth.user_id
      render json: {}, status: :forbidden
    else
      render json: @user
    end
  end
end
