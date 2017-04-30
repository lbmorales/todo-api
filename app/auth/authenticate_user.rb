class AuthenticateUser
  # Service entry point
  def self.call(email, password)
    user = User.find_by!(email: email)
    unless user.authenticate(password)
      raise ExceptionHandler::AuthenticationError, Message.invalid_credentials
    end
    encoded_token = JsonWebToken.encode(user_id: user.id)
    encoded_token
  rescue ActiveRecord::RecordNotFound
    raise ExceptionHandler::AuthenticationError, Message.invalid_credentials
  end

  # def self.call(email, password)
  #   user = User.find_by!(email: email)
  #   raise ExceptionHandler::AuthenticationError, Message.invalid_credentials unless user.authenticate(password)
  #   encoded_token = JsonWebToken.encode(user_id: user.id)
  #   encoded_token
  # rescue ActiveRecord::RecordNotFound => e
  #   raise ExceptionHandler::AuthenticationError, Message.invalid_credentials
  # end
end
