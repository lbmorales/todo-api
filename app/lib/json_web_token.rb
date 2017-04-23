class JsonWebToken
  # Secret to encode an decode JsonWebToken
  HMAC_SECRET = Rails.application.secrets.secret_key_base # Cada aplicacion de rails tiene un secret

  def self.encode(payload, exp = 8.month.from_now)
    puts '>>>>>>>>>> JsonWebToken encode called'
    # set to expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
    # Sing token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    puts '>>>>>>>>>> JsonWebToken dencode called'
    # get payload, first index in decoded array

    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    # raise custom error to be handled by custom handler
    raise ExceptionHandler::ExpiredSignature, e.message
  end
end
