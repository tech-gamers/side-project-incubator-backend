module ActionController
  module RequestForgeryProtection
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
        Rails.logger.debug("request.baseurl=#{request.base_url}")
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
  end
end
