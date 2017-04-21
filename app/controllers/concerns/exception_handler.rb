module ExceptionHandler
  # provide the more 'grateful included' provided
  # this module rescue from ActiveRecord exception when
  # set_todo throw exception 'cause record does not exists,
  # set to return a 404 message

  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardErrors; end
  class MissingToken < StandardErrors; end
  class InvalidToken < StandardErrors; end

  included do
    # This bock was added for token based authentication
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    #

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found) # message defined on messages.rb
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end

  private

  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized) # message defined on messages.rb
  end
end
