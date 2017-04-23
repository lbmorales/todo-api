class AuthenticateUser
  # this class is responsible for authenticating user receive email and pwd
  # checks if they are valid and then creates a token with the user id as the payload.
  # or raise exception: invalid credentials
  def initialize(email, password)
    @email = email
    @password = password
  end

  # Service entry point
  def call
    puts '>>>>>>>>>  AuthenticateUser called' 
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_reader :email, :password

  # Verify user credentials
  def user
    user = User.find_by(email: email)
    return user if user && user.authenticate(password)
    # Raise exception error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
