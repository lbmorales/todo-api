class JsonWebToken
  # Secret to encode an decode JsonWebToken
  HMAC_SECRET = Rails.application.secrets.secret_key_base # ????????????????????

  def self.encode(payload, exp = 24.hours.from_now)
    # set to expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
    # Sing token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    # get payload, first index in decoded array

    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    # raise custom error to be handled by custom handler
    raise ExceptionHandler::ExpiredSignature, e.message
  end
end
