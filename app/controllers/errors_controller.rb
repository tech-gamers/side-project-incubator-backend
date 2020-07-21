class ErrorsController < ApplicationController
  protect_from_forgery with: :null_session

  def not_found
    render json: {}, status: :not_found
  end
end