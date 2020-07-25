require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Errors
    # https://stackoverflow.com/a/37174557/2214973
    # config.exceptions_app = routes

    # API
    config.api_only = true

    # Hosts
    config.hosts << "localhost"
    config.hosts << "api.tech-gamers.live"
    config.hosts << 'tech-gamers.live'
    config.hosts << 'liu-backend.com'
    config.hosts << 'rails.liu-backend.com'

    # Logging
    config.log_level = ENV.fetch('LOG_LEVEL', :debug)

    # Middlewares
    ## CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i[get patch put delete post options head],
                 expose: %w[X-CSRF-Token Set-Cookie]
      end
    end
    ## Cache
    config.cache_store = :redis_cache_store, {
      url: ENV.fetch('REDIS_URL', 'redis://redis'),
      connect_timeout: 20,
      read_timeout: 0.2,
      write_timeout: 0.2,
      reconnect_attempts: 1,
      error_handler: lambda { |method:, returning:, exception:|
        Reporter.capture_exception(
          exception,
          level: 'warning',
          tags: { method: method, returning: returning }
        )
      }
    }
    ## Session
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore,
                          key: '_SPI_session',
                          secure: Rails.env.production?,
                          expire_after: 14.days,
                          domain: :all,
                          tld_length: 2
    ## Authentication
    config.middleware.use Warden::Manager do |m|
      m.default_strategies :jwt
      m.failure_app = proc { |env|
        [
          '401',
          { 'Content-Type' => 'application/json' },
          [
            {
              error: env['warden'].message || 'Unauthorized',
              code: 401
            }.to_json
          ]
        ]
      }
    end
    ## OAuth2
    env = Rails.env.production? ? :prod : :dev
    config.middleware.use OmniAuth::Builder do
      provider :developer if Rails.env.development?
      unless Rails.env.test?
        provider :github,
                 Rails.application.credentials&.github&.dig(:oauth, env, :id),
                 Rails.application.credentials&.github&.dig(:oauth, env, :secret)
      end
    end

    # Tests
    config.generators.system_tests = nil
  end
end
