module CsrfProtection
  extend ActiveSupport::Concern
  include ControllerUtils # set_cookie
  include ActionController::RequestForgeryProtection

  included do
    after_action :set_csrf_cookie
  end

  protected

  def set_csrf_cookie
    response.headers['X-CSRF-Token'] = masked_authenticity_token(session)
  end
end
