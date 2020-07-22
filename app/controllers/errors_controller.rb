class ErrorsController < ApplicationController
  def not_found
    render json: {}, status: :not_found
  end
end
