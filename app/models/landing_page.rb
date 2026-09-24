class LandingPage < ApplicationRecord
  validates :public_identifier, presence: true, uniqueness: true
  validate :current_data_must_be_present

  private

  def current_data_must_be_present
    errors.add(:current_data, :blank) if current_data.nil?
  end
end
