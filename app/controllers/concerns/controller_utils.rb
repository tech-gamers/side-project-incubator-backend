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
    defaults = { secure: true, httponly: true }
    cookies[name] = defaults.merge(opts).merge(value: value)
  end
end
