class Asset < ApplicationRecord
  belongs_to :user

  has_one_attached :file

  validates :user, presence: true
  validate :file_must_be_attached

  private

  def file_must_be_attached
    errors.add(:file, "must be attached") unless file.attached?
  end
end
