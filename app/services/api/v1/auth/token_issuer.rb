module Api
  module V1
    module Auth
      class TokenIssuer
        def self.call(user)
          {
            access_token: access_token_for(user),
            refresh_token: refresh_token_for(user)
          }
        end

        def self.access_token_for(user)
          access_token, = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
          access_token
        end

        def self.refresh_token_for(user)
          _refresh_record, refresh_token = RefreshToken.issue_for(user)
          refresh_token
        end
      end
    end
  end
end
