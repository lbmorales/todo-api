class User < ApplicationRecord
    # has secure password
    has_secure_password

    # Model associations, declare foreign_key when the reference field is not by default (Ej. user_id)
    has_many :todos, foreign_key: :created_by, dependent: :destroy

    #Validations
    validates_presence_of :name, :email, :password_digest

end
