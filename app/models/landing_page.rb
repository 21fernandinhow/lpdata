class LandingPage < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :public_id, uniqueness: true
  before_validation :normalize_allowed_hosts
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

  def normalize_allowed_hosts
    self.allowed_hosts = Array(allowed_hosts).map { |host| host.to_s.downcase }
  end
end
