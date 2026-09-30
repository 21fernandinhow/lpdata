module McpTools
  class CreateLandingPage < Base
    tool_name "create_landing_page"
    title "Create a landing page"
    description <<~DESCRIPTION
      Creates a landing page owned by the authenticated account and returns the
      whole record, including the `id` used by the management tools and the
      `public_id` a Consuming Application reads the content with.
    DESCRIPTION

    input_schema(
      properties: {
        name: {
          type: "string",
          description: "Human name of the landing page. It is not the public identifier."
        },
        current_data: {
          type: "object",
          description: ContentDocumentContract::ARGUMENT
        },
        allowed_hosts: {
          type: "array",
          items: { type: "string" },
          description: "Hosts allowed to read the content from a browser with the higher rate limit, " \
                       "such as \"example.com\" or \"www.example.com\". Defaults to an empty list."
        }
      },
      required: %w[name current_data]
    )

    def self.call(name:, current_data:, allowed_hosts: nil, server_context: nil)
      attributes = LandingPageAttributeFilter.call({
        "name" => name,
        "current_data" => normalize_json(current_data),
        "allowed_hosts" => allowed_hosts
      })

      landing_page = current_user.landing_pages.new(attributes)

      if landing_page.save
        json_response(landing_page: landing_page.as_json)
      else
        validation_error_response(landing_page)
      end
    end
  end
end
