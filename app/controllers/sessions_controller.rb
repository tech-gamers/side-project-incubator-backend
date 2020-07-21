class SessionsController < ApplicationController
  def destroy
    if current_auth
      log_out(current_auth)
    end
    render json: {}, status: :no_content
  end
end
