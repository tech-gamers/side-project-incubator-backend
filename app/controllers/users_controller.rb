class UsersController < ApplicationController
  before_action :authenticate_auth!

  def show
    @user = current_auth.user
    if @user.id.to_s != params[:id]
      render json: {}, status: :forbidden
    end
  end
end
