require 'rails_helper'

RSpec.describe User, type: :model do
  # Associatin test
  # Ensure User model have 1:m relationship with todos
  it { should have_many(:todos) }

  # Validation test
  # Ensure name, email and password_digest is present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
end
