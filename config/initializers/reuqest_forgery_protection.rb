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
      if request.origin == "null"
        raise InvalidAuthenticityToken, NULL_ORIGIN_MESSAGE
      end

      if request.origin.present?
        @strip_domain_pattern ||= %r{(?<protocol>https?)://(?<domain>.*)}.freeze
        unless (match = @strip_domain_pattern.match(request.origin))
          Rails.logger.info("wrong origin format: #{request.origin}")
          return false
        end
        protocol = match[:protocol]
        origin = match[:domain]
        if protocol != 'https' && PublicSuffix.domain(origin) != 'tech-gamers.live'
          Rails.logger.info("CSRF origin not valid")
          Rails.logger.debug("request.origin=#{request.origin}")
          Rails.logger.debug("origin=#{origin}")
          Rails.logger.debug("protocol=#{protocol}")
          Rails.logger.debug("request.base_url=#{request.base_url}")
          return false
        end
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
