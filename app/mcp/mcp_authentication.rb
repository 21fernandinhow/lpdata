# Identifies the caller of an MCP request from the credential headers, before
# the transport sees it. There is no login tool and no token: every request
# carries the credential, exactly like the sign-in endpoint.
class McpAuthentication
  EMAIL_HEADER = "X-LPData-Email"
  PASSWORD_HEADER = "X-LPData-Password"

  MISSING_CREDENTIALS_MESSAGE =
    "Unauthorized: send your LPData credentials in the #{EMAIL_HEADER} and #{PASSWORD_HEADER} headers.".freeze
  INVALID_CREDENTIALS_MESSAGE =
    "Unauthorized: the credentials in #{EMAIL_HEADER} and #{PASSWORD_HEADER} do not match an LPData account.".freeze

  # Verifying a password costs bcrypt at Devise's stretches, a few hundred
  # milliseconds. Binding the result to the MCP session pays that once per
  # session instead of once per tool call. The key covers the credential
  # itself, so a hit only ever happens for the same account presenting the
  # same password: the cache skips the bcrypt round, never the identity check.
  CACHE_TTL = 15.minutes

  attr_reader :email, :password, :session_id

  def initialize(env)
    @email = env["HTTP_X_LPDATA_EMAIL"].to_s
    @password = env["HTTP_X_LPDATA_PASSWORD"].to_s
    @session_id = env["HTTP_MCP_SESSION_ID"].to_s
  end

  def credentials_present?
    email.present? && password.present?
  end

  def user
    return @user if defined?(@user)

    @user = credentials_present? ? (cached_user || verified_user) : nil
  end

  def error_message
    credentials_present? ? INVALID_CREDENTIALS_MESSAGE : MISSING_CREDENTIALS_MESSAGE
  end

  # Called with the session id the transport issued on `initialize`, so the very
  # next request already hits the cache.
  def remember(issued_session_id)
    return if issued_session_id.blank? || user.nil?

    Rails.cache.write(cache_key(issued_session_id), user.id, expires_in: CACHE_TTL)
  end

  private

  def cached_user
    return if session_id.blank?

    user_id = Rails.cache.read(cache_key(session_id))
    user_id && User.find_by(id: user_id)
  end

  def verified_user
    user = User.find_by(email: email)
    return unless user&.valid_password?(password)

    Rails.cache.write(cache_key(session_id), user.id, expires_in: CACHE_TTL) if session_id.present?
    user
  end

  def cache_key(id)
    "mcp-session-user:#{id}:#{credential_digest}"
  end

  # Keyed rather than plain so the cache never holds anything derived from the
  # password on its own.
  def credential_digest
    OpenSSL::HMAC.hexdigest(
      "SHA256",
      Rails.application.secret_key_base,
      "#{email}\0#{password}"
    )
  end
end
