class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :validatable,
      :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

    has_many :refresh_tokens, dependent: :destroy
    has_many :landing_pages, dependent: :destroy
    has_many :assets, dependent: :destroy
end
