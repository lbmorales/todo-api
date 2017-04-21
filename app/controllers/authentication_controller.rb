class AuthenticationController < ApplicationController
    # expose an /auth/login endpoint that accepts user credentials 
    # returns a JSON response with the result.

    # POST auth/login
    def authenticate
        auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
        json_response(auth_token: auth_token)
    end

    private

    def auth_params
        params.permit(:email, :password)
    end
end
