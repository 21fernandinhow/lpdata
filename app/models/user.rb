class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :validatable,
      :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

    has_many :refresh_tokens, dependent: :destroy
end
