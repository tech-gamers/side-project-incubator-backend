class Reporter
  class << self
    delegate :capture_exception,
             :capture_message,
             to: :raven_reporter

    def logger
      @logger ||= Rails.logger
    end

    def raven_reporter
      @raven_reporter ||= Raven
    end

    if Rails.env.development?
      def capture_exception(err)
        logger.error(err.message)
        err.backtrace.each { |l| logger.debug(l) }
      end

      def capture_message(msg)
        logger.debug(msg)
      end
    elsif Rails.env.test?
      def capture_exception(err)
        raise err
      end

      def capture_message(msg)
        raise msg
      end
    end
  end
end
