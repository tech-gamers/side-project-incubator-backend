module ControllerUtils
  # Set secure cookie by default.
  # @param name [String]
  # @param value [String]
  # @param opts [Hash]
  # @example
  #   set_cookie('cookie_name', 'xxxxxxxxxx',
  #     expires: 10.minutes.from_now,
  #     :domain: 'www.example.com',
  #   )
  def set_cookie(name, value, opts = {})
    # https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html#samesite-cookie-attribute
    defaults = { secure: Rails.env.production?, httponly: true, same_site: "Lax" }
    cookies[name] = defaults.merge(opts).merge(value: value)
  end
end
