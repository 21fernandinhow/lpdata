module Api
  module V1
    module Auth
      class TokensController < ApplicationController
        def refresh
          result = RefreshToken.rotate(params.require(:refresh_token))

          unless result
            render json: { errors: [ "Invalid or expired refresh token" ] }, status: :unauthorized
            return
          end

          user, refresh_token = result
          render json: {
            user: { id: user.id, email: user.email },
            access_token: TokenIssuer.access_token_for(user),
            refresh_token: refresh_token
          }
        end
      end
    end
  end
end
