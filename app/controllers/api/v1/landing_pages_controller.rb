module Api
  module V1
    class LandingPagesController < ApplicationController
      def show
        landing_page = LandingPage.find_by!(public_identifier: params[:public_identifier])

        render json: landing_page.current_data
      end
    end
  end
end
