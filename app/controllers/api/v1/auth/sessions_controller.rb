module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        def create
          user = User.find_by(email: session_params[:email])

          if user&.valid_password?(session_params[:password])
            render json: {
              user: { id: user.id, email: user.email },
              **TokenIssuer.call(user)
            }
          else
            render json: { errors: [ "Invalid email or password" ] }, status: :unauthorized
          end
        end

        def destroy
          refresh_revoked = RefreshToken.revoke(params.require(:refresh_token))
          access_token = request.headers["Authorization"].to_s.delete_prefix("Bearer ")
          access_revoked = access_token.blank? || AccessTokenRevoker.call(access_token)

          if refresh_revoked && access_revoked
            head :no_content
          else
            render json: { errors: [ "Invalid or expired refresh token" ] }, status: :unauthorized
          end
        end

        private

        def session_params
          params.require(:user).permit(:email, :password)
        end
      end
    end
  end
end
