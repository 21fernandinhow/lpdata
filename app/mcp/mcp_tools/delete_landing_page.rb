module McpTools
  class DeleteLandingPage < Base
    tool_name "delete_landing_page"
    title "Delete a landing page"
    description <<~DESCRIPTION
      Deletes a landing page of the authenticated account. The Content Document
      goes with it and LPData keeps no history of it.
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

      landing_page.destroy!

      json_response(deleted: true, id: landing_page.id)
    end
  end
end
