module Api
  module V1
    class LandingPagesController < ApplicationController
      before_action :authenticate_user!, only: %i[create index manage_show update destroy]
      before_action :throttle_public_read, only: :show

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

        if landing_page.update(landing_page_attributes(allow_partial: true))
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
        render json: @landing_page.current_data
      end

      private

      def landing_page_params
        params.require(:landing_page)
      end

      def landing_page_attributes(allow_partial: false)
        attributes = landing_page_params
        keys = allow_partial ? attributes.keys : %w[name current_data allowed_hosts]

        keys.each_with_object({}) do |key, permitted|
          permitted[key.to_sym] = attributes[key] if %w[name current_data allowed_hosts].include?(key)
        end
      end

      def throttle_public_read
        @landing_page = LandingPage.find_by!(public_id: params[:public_id])
        limit = configured_origin? ? 1_000 : 30

        return if PublicRateLimiter.new.allowed?(ip: request.remote_ip, limit: limit)

        response.set_header("Retry-After", "60")
        render json: { error: "Too many requests" }, status: :too_many_requests
      end

      def configured_origin?
        origin = request.headers["Origin"]
        return false if origin.blank?

        uri = URI.parse(origin)
        return false if uri.host.blank?

        origin_host = uri.host.downcase
        origin_port = uri.port
        @landing_page.allowed_hosts.any? do |allowed_host|
          allowed_host == origin_host ||
            (allowed_host.exclude?(":") && origin_host.end_with?(".#{allowed_host}")) ||
            allowed_host == "#{origin_host}:#{origin_port}"
        end
      rescue URI::InvalidURIError
        false
      end
    end
  end
end
