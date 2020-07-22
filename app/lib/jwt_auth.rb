class JwtAuth
  class << self
    CURVE = 'prime256v1'.freeze
    ALGO = 'ES256'.freeze
    EXP = 2.weeks
    DEV_PEM_PATH = Rails.root.join('tmp/jwt.pem')

    def pri_key
      if @pri_key
        @pri_key
      elsif Rails.env.production?
        pem = Rails.application.credentials.jwt[:pem]
        @pri_key = OpenSSL::PKey.read(pem)
      elsif File.exist?(DEV_PEM_PATH)
        pem = File.read(DEV_PEM_PATH)
        @pri_key = OpenSSL::PKey.read(pem)
      else
        @pri_key = OpenSSL::PKey::EC.new(CURVE).tap do |k|
          k.generate_key
          File.write(DEV_PEM_PATH, k.to_pem)
        end
      end
    end

    def pub_key
      if @pub_key
        return @pub_key
      end

      @pub_key = OpenSSL::PKey::EC.new(pri_key)
      @pub_key.private_key = nil
      @pub_key
    end

    def sign(user, valid_since = Time.current)
      auth = Auth.for_jwt(user)
      payload = {
        data: {
          id: auth.id
        },
        nbf: valid_since.to_i,
        exp: (valid_since + EXP).to_i
      }
      JWT.encode(payload, pri_key, ALGO)
    end

    def authenticate_auth(token)
      payload, _headers = JWT.decode(token, pub_key, true, { algorithm: ALGO })
      id = payload.dig('data', 'id')
      Auth.find_by(id: id)
    rescue JWT::ExpiredSignature
      "token expired"
    rescue JWT::ImmatureSignature
      "token not valid yet"
    rescue JWT::VerificationError
      "invalid signature"
    rescue JWT::DecodeError
      "bad token"
    end
  end
end
