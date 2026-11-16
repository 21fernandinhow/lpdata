module Auth
  class AccessTokenRevoker
    def self.call(token)
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      JwtDenylist.revoke_jwt(payload, nil)
      true
    rescue JWT::ExpiredSignature
      # An expired token no longer authenticates, so it needs no denylist entry.
      true
    rescue JWT::DecodeError
      false
    end
  end
end
