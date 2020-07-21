class ApplicationController < ActionController::Base
  before_action :set_raven_context

  rescue_from Exception, with: :error_handler

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
      Raven.capture_exception(err)
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
