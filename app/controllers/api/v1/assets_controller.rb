module Api
  module V1
    class AssetsController < ApplicationController
      before_action :authenticate_user!, only: %i[index show create destroy]
      before_action :set_asset, only: %i[show destroy]

      def index
        render json: { assets: current_user.assets.map { |asset| serialized_asset(asset) } }
      end

      def show
        render json: { asset: serialized_asset(@asset) }
      end

      def create
        asset = current_user.assets.new
        asset.file.attach(asset_params[:file])

        if asset.save
          render json: { asset: serialized_asset(asset) }, status: :created
        else
          render json: { errors: asset.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        @asset.destroy!
        head :no_content
      end

      private

      def asset_params
        params.require(:asset).permit(:file)
      end

      def set_asset
        @asset = current_user.assets.find(params[:id])
      end

      def serialized_asset(asset)
        {
          id: asset.id,
          user_id: asset.user_id,
          filename: asset.file.blob.filename.to_s,
          content_type: asset.file.blob.content_type,
          byte_size: asset.file.blob.byte_size,
          public_url: Rails.application.routes.url_helpers.rails_blob_url(
            asset.file,
            host: request.base_url,
            only_path: false
          )
        }
      end
    end
  end
end
