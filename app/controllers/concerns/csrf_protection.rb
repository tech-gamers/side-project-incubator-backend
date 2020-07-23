module CsrfProtection
  extend ActiveSupport::Concern
  include ControllerUtils # set_cookie
  include ActionController::RequestForgeryProtection

  included do
    after_action :set_csrf_cookie
  end

  protected

  def set_csrf_cookie
    set_cookie('csrf_token', form_authenticity_token)
  end
end
