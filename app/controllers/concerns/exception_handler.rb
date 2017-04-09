module ExceptionHandler
  # provide the more 'grateful included' provided
  # this module rescue from ActiveRecord exception when
  # set_todo throw exception 'cause record does not exists,
  # set to return a 404 message

  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
