class ApplicationController < ActionController::Base
  before_action :set_raven_context

  # TODO: fix it later
  skip_before_action :verify_authenticity_token

  rescue_from Exception, with: :error_handler

  protected

  def authenticate
    unless auth_signed_in?
      render json: {}, status: :unauthorized
    end
  end

  private

  def process(action, *args, &block)
    super
  rescue AbstractController::ActionNotFound
    render json: {}, status: :method_not_allowed
  end

  def error_handler(err)
    result = {}
    case err
    when ActiveRecord::RecordNotFound
      result[:status] = 404
    end
    if result.present?
      render({ json: {} }.merge(result))
    else
      Reporter.capture_exception(err)
      render json: {}, status: :internal_server_error
    end
  end

  def set_raven_context
    Raven.user_context(id: current_auth&.user_id)
    Raven.extra_context(
      auth_id: current_auth&.id,
      params: params.to_unsafe_h,
      url: request.url
    )
  end
end
