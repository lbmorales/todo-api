class AuthorizeApiRequest
  # The AuthorizeApiRequest service gets the token from the authorization headers,
  # attempts to decode it to return a valid user object
  def initialize(headers = {})
    @headers = headers
  end

  # service entry point : return valid user abject on hash form
  def call
    { user: user }
  end

  private

  attr_reader :headers # Esto es para no tener que decir @header en el codigo sino header simplemente

  def user
    # Check if user is in the db
    # memorize user object
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  # handle user not found
  rescue ActiveRecord::RecordNotFound => e
    # raise custom error
    raise(ExceptionHandler::InvalidToken, ("#{Message.invalid_token} #{e.message}"))
  end

  # decode token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # Extract token from 'Authorization' header
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    raise(ExceptionHandler::MissingToken, Message.missing_token)
  end
end
