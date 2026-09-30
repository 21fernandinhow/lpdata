module McpTools
  class UpdateLandingPage < Base
    tool_name "update_landing_page"
    title "Update a landing page"
    description <<~DESCRIPTION
      Updates a landing page of the authenticated account. The update is partial
      over the arguments: whatever you omit is left alone. `current_data`,
      however, is never merged — sending it replaces the whole Content Document,
      so send the complete document you want stored.
    DESCRIPTION

    input_schema(
      properties: {
        id: { type: "integer", description: "Management id of the landing page, not its public_id." },
        name: { type: "string", description: "New human name. Omit to keep the current one." },
        current_data: {
          type: "object",
          description: "#{ContentDocumentContract::ARGUMENT}\nOmit to keep the stored document."
        },
        allowed_hosts: {
          type: "array",
          items: { type: "string" },
          description: "New list of hosts allowed to read from a browser with the higher rate limit. " \
                       "It replaces the stored list. Omit to keep it."
        }
      },
      required: %w[id]
    )

    def self.call(id:, name: UNSET, current_data: UNSET, allowed_hosts: UNSET, server_context: nil)
      landing_page = current_user.landing_pages.find_by(id: id)
      return not_found_response("Landing page") unless landing_page

      changes = {}
      changes["name"] = name if given(name)
      changes["current_data"] = normalize_json(current_data) if given(current_data)
      changes["allowed_hosts"] = allowed_hosts if given(allowed_hosts)

      attributes = LandingPageAttributeFilter.call(changes, allow_partial: true)

      if landing_page.update(attributes)
        json_response(landing_page: landing_page.as_json)
      else
        validation_error_response(landing_page)
      end
    end
  end
end
