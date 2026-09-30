module McpTools
  class GetLandingPage < Base
    tool_name "get_landing_page"
    title "Get a landing page"
    description <<~DESCRIPTION
      Returns one landing page of the authenticated account, Content Document
      included. #{ContentDocumentContract::POINTER}

      A landing page owned by another account is reported as not found, exactly
      as the API reports it.
    DESCRIPTION

    input_schema(
      properties: {
        id: { type: "integer", description: "Management id of the landing page, not its public_id." }
      },
      required: %w[id]
    )

    def self.call(id:, server_context: nil)
      landing_page = current_user.landing_pages.find_by(id: id)
      return not_found_response("Landing page") unless landing_page

      json_response(landing_page: landing_page.as_json)
    end
  end
end
