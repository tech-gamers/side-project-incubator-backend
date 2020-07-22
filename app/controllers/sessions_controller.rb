class SessionsController < ApplicationController
  def destroy
    if current_auth
      log_out
    end
    render json: {}, status: :no_content
  end
end
