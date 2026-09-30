module McpTools
  class GetPublicContent < Base
    tool_name "get_public_content"
    title "Read the published content"
    description <<~DESCRIPTION
      Reads a landing page by its `public_id` and returns the Content Document
      raw, with no envelope around it: byte for byte what a Consuming
      Application receives from `GET /landing_pages/<public_id>`. Use it to
      confirm what readers actually see.

      The read is public and not scoped to the authenticated account, and it
      carries the same limit as the public endpoint:
      #{PublicRateLimiter::DEFAULT_LIMIT} requests per minute per IP for a
      caller whose origin is not in the landing page `allowed_hosts`, which is
      the case for this server.

      #{ContentDocumentContract::POINTER}
    DESCRIPTION

    input_schema(
      properties: {
        public_id: {
          type: "integer",
          description: "Public identifier of the landing page, not its management id."
        }
      },
      required: %w[public_id]
    )

    def self.call(public_id:, server_context: nil)
      landing_page = LandingPage.find_by(public_id: public_id)
      return not_found_response("Landing page") unless landing_page

      unless throttler.allowed?(ip: Current.ip_address, limit: PublicRateLimiter::DEFAULT_LIMIT)
        return error_response("Too many requests. Retry-After: #{PublicRateLimiter::WINDOW.to_i} seconds.")
      end

      text_response(JSON.pretty_generate(landing_page.current_data))
    end

    def self.throttler
      PublicRateLimiter.new
    end
    private_class_method :throttler
  end
end
