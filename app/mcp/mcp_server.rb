# Builds the MCP server and its Streamable HTTP transport.
#
# The transport keeps session state in memory, so it must be a single object
# shared by every request of the process, and the process must be the only one
# serving the endpoint. config/puma.rb declares no `workers`, so the app runs
# single-process today; adding workers or instances means moving the transport
# to the gem's stateless mode.
class McpServer
  NAME = "lpdata".freeze
  TITLE = "LPData".freeze
  VERSION = "1.0.0".freeze

  INSTRUCTIONS = <<~INSTRUCTIONS.freeze
    Manage the content of LPData landing pages. Start with check_connection: it
    confirms which account this session is authenticated as and carries the
    Content Document contract that every current_data argument must follow.
  INSTRUCTIONS

  TOOLS = [
    McpTools::CheckConnection,
    McpTools::CreateLandingPage,
    McpTools::ListLandingPages,
    McpTools::GetLandingPage,
    McpTools::UpdateLandingPage,
    McpTools::DeleteLandingPage,
    McpTools::GetPublicContent,
    McpTools::ListAssets,
    McpTools::GetAssetUploadCommand,
    McpTools::DeleteAsset
  ].freeze

  def self.transport
    @transport ||= MCP::Server::Transports::StreamableHTTPTransport.new(
      server,
      # One JSON object per call instead of an SSE stream: every tool here is a
      # single synchronous database round trip with nothing to stream.
      enable_json_response: true,
      # The endpoint is server-to-server and carries no CORS grant, so a browser
      # cannot reach it cross-origin; Rails validates the Host itself.
      dns_rebinding_protection: false,
      # No resources and no prompts, so there is nothing to subscribe to.
      serve_subscriptions_listen: false
    )
  end

  def self.server
    MCP::Server.new(
      name: NAME,
      title: TITLE,
      version: VERSION,
      instructions: INSTRUCTIONS,
      tools: TOOLS
    )
  end
end
