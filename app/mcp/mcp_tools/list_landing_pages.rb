module McpTools
  class ListLandingPages < Base
    tool_name "list_landing_pages"
    title "List landing pages"
    description <<~DESCRIPTION
      Lists the landing pages of the authenticated account without their Content
      Documents, so the list stays readable. Use get_landing_page for the
      document of one of them.
    DESCRIPTION

    input_schema(properties: {}, required: [])

    def self.call(server_context: nil)
      landing_pages = current_user.landing_pages.map { |page| page.as_json(except: "current_data") }

      json_response(landing_pages: landing_pages)
    end
  end
end
