class UsersController < ApplicationController

  skip_before_action :authorize_request, only: :create

  # POST /signup
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.call(user.email, user.password)
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
