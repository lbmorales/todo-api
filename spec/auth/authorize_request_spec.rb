require 'rails_helper'
require 'ostruct'

RSpec.describe AuthorizeRequest do
  describe '.call' do
    context 'when request is valid' do
      let(:user) { create(:user) }
      let(:valid_request) { OpenStruct.new(headers: { 'Authorization' => token_generator(user.id) }) }
      it 'returns the user object' do
        expect(AuthorizeRequest.call(valid_request)).to eq(user)
      end
    end

    context 'when token was not provided' do
      let(:invalid_request) { OpenStruct.new(headers: {}) }
      it 'raises MissingToken exception' do
        expect { AuthorizeRequest.call(invalid_request) }
          .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
      end
    end

    context 'when token is malformed' do
      let(:invalid_request) { OpenStruct.new(headers: { 'Authorization' => '1234' }) }
      it 'raises InvalidToken exception' do
        expect { AuthorizeRequest.call(invalid_request) }
          .to raise_error(ExceptionHandler::InvalidToken)
      end
    end

    context 'when token is expired' do
      let(:user) { create(:user) }
      let(:request) { OpenStruct.new(headers: { 'Authorization' => expired_token_generator(user.id) }) }

      it 'raises ExceptionHandler::ExpiredSignature error' do
        expect { AuthorizeRequest.call(request) }
          .to raise_error(
            ExceptionHandler::ExpiredSignature,
            /Signature has expired/
          )
      end
    end
  end
end
