require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  # create test user
  let(:user) { create(:user) }
  # mock 'authorization' header
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  # Invalid request subject
end
