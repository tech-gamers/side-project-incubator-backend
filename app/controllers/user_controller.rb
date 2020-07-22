class UserController < ApplicationController
  before_action :authenticate!

  def show
    render json: current_user, serializer: UserSerializer
  end
end
