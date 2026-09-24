module Api
  module V1
    class LandingPagesController < ApplicationController
      before_action :authenticate_user!, only: %i[create index manage_show update destroy]

      def create
        landing_page = current_user.landing_pages.new(landing_page_attributes)

        if landing_page.save
          render json: { landing_page: landing_page }, status: :created
        else
          render json: { errors: landing_page.errors.full_messages }, status: :unprocessable_content
        end
      end

      def index
        render json: { landing_pages: current_user.landing_pages }
      end

      def manage_show
        landing_page = current_user.landing_pages.find(params[:id])

        render json: { landing_page: landing_page }
      end

      def update
        landing_page = current_user.landing_pages.find(params[:id])

        if landing_page.update(landing_page_attributes)
          render json: { landing_page: landing_page }
        else
          render json: { errors: landing_page.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        current_user.landing_pages.find(params[:id]).destroy!
        head :no_content
      end

      def show
        landing_page = LandingPage.find_by!(public_id: params[:public_id])

        render json: landing_page.current_data
      end

      private

      def landing_page_params
        params.require(:landing_page)
      end

      def landing_page_attributes
        attributes = landing_page_params
        {
          name: attributes[:name],
          current_data: attributes[:current_data]
        }
      end
    end
  end
end
