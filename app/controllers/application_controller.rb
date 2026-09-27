class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    resource = exception.model&.underscore&.humanize || "Resource"
    render json: { error: "#{resource} not found" }, status: :not_found
  end
end
