module Api
  module V1
    module Auth
      class AccessTokenRevoker
        def self.call(token)
          payload = Warden::JWTAuth::TokenDecoder.new.call(token)
          JwtDenylist.revoke_jwt(payload, nil)
          true
        rescue JWT::DecodeError
          false
        end
      end
    end
  end
end
