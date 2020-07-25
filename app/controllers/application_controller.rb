class ApplicationController < ActionController::API
  include Authentication
  include CsrfProtection
  include ActionController::Cookies

  protect_from_forgery with: :exception
  before_action :set_raven_context

  rescue_from Exception, with: :error_handler

  # rubocop:disable Metrics/AbcSize
  def verified_request?
    unless protect_against_forgery?
      Rails.logger.info("CSRF not protecting")
      return true
    end
    if request.get? || request.head?
      Rails.logger.info("CSRF bypassed for safe requests")
      return true
    end
    unless valid_request_origin?
      Rails.logger.info("CSRF origin not valid")
      Rails.logger.debug("request.origin=#{request.origin}")
      Rails.logger.debug("request.baseurl=#{request.baseurl}")
      return false
    end
    if any_authenticity_token_valid?
      Rails.logger.info("CSRF check passed!")
      true
    else
      Rails.logger.info("CSRF check failed!")
      Rails.logger.debug("form_authenticity_param=#{form_authenticity_param}")
      Rails.logger.debug("request.x_csrf_token=#{request.x_csrf_token}")
      false
    end
  end
  # rubocop:enable Metrics/AbcSize

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
      result[:status] = :not_found
    when ActionController::MissingExactTemplate
      result[:status] = :not_implemented
    when ActionController::InvalidAuthenticityToken
      result[:status] = :unprocessable_entity
      result[:json] = { error: "invalid authentication token" }
      # signout
    end
    if result.present?
      render({ json: {} }.merge(result))
    else
      Reporter.capture_exception(err)
      render json: {}, status: :internal_server_error
    end
  end

  def set_raven_context
    Raven.user_context(id: current_user&.id)
    Raven.extra_context(
      auth_id: current_auth&.id,
      params: params.to_unsafe_h,
      url: request.url
    )
  end
end
