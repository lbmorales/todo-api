require 'rails_helper'
require 'ostruct'

RSpec.describe AuthenticateUser do
  let(:valid_user) { create(:user) }
  let(:invalid_user) { OpenStruct.new(email: 'unexisting@email.com', password: 'foo') }

  # Test suite for AuthenticateUser#call
  describe '.call' do
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = AuthenticateUser.call(valid_user.email, valid_user.password)
        expect(token).not_to be_nil
      end
    end

    context 'when invalid credentials' do
      it 'raises an authentication error' do
        expect { AuthenticateUser.call(invalid_user.email, invalid_user.password) }
          .to raise_error(ExceptionHandler::AuthenticationError, /Invalid credentials/)
      end
    end
  end
end
