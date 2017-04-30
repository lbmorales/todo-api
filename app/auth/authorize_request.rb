class AuthorizeRequest
  def self.call(request)
    authorization_header = request.headers['Authorization']
    raise ExceptionHandler::MissingToken, Message.missing_token unless authorization_header.present?

    encoded_token = authorization_header.split(' ').last
    decoded_token = JsonWebToken.decode(encoded_token)

    user = User.find(decoded_token[:user_id])
    user
  rescue ActiveRecord::RecordNotFound => e
    raise ExceptionHandler::InvalidToken, "#{Message.invalid_token} #{e.message}"
  end
end
