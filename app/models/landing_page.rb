class LandingPage < ApplicationRecord
  validates :public_identifier, presence: true, uniqueness: true
  validate :current_data_must_be_present
  validate :current_data_must_follow_editable_field_convention

  private

  def current_data_must_be_present
    errors.add(:current_data, :blank) if current_data.nil?
  end

  def current_data_must_follow_editable_field_convention
    ContentDocumentValidator.errors_for(current_data).each do |message|
      errors.add(:current_data, message)
    end
  end
end
