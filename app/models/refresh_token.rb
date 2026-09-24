class RefreshToken < ApplicationRecord
  belongs_to :user

  def self.issue_for(user)
    raw_token = SecureRandom.urlsafe_base64(48)
    token = create!(
      user: user,
      token_digest: Digest::SHA256.hexdigest(raw_token),
      expires_at: 30.days.from_now
    )

    [ token, raw_token ]
  end

  def self.rotate(raw_token)
    token = find_by(token_digest: Digest::SHA256.hexdigest(raw_token))
    return unless token

    token.with_lock do
      return unless token.active?

      token.update!(revoked_at: Time.current)
      _new_token, new_raw_token = issue_for(token.user)
      [ token.user, new_raw_token ]
    end
  end

  def self.revoke(raw_token)
    token = find_by(token_digest: Digest::SHA256.hexdigest(raw_token))
    return false unless token

    token.with_lock do
      return false unless token.active?

      token.update!(revoked_at: Time.current)
      true
    end
  end

  def active?
    revoked_at.nil? && expires_at.future?
  end
end
