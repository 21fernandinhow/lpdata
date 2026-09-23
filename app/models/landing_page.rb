class LandingPage < ApplicationRecord
  validates :public_identifier, presence: true, uniqueness: true
  validates :current_data, presence: true
end
