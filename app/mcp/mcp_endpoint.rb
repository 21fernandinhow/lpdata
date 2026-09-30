# The Rack app mounted at /mcp. It authenticates the request, puts the caller
# on Current for the tools to read, and hands the request to the MCP transport.
class McpEndpoint
  UNAUTHORIZED_CODE = -32_001

  # Built once per code load, on the boot thread, by the to_prepare hook in
  # config/initializers/mcp_server.rb. The transport behind it holds the session
  # state, so every request of the process has to reach the same object.
  def self.instance
    @instance ||= new
  end

  def initialize(transport: McpServer.transport)
    @transport = transport
  end

  def call(env)
    authentication = McpAuthentication.new(env)
    user = authentication.user

    return unauthorized(authentication.error_message) unless user

    request = ActionDispatch::Request.new(env)

    Current.set(user: user, base_url: request.base_url, ip_address: request.remote_ip) do
      status, headers, body = @transport.call(env)
      authentication.remember(headers["mcp-session-id"])
      [ status, headers, body ]
    end
  end

  private

  def unauthorized(message)
    body = {
      jsonrpc: "2.0",
      id: nil,
      error: { code: UNAUTHORIZED_CODE, message: message }
    }.to_json

    [ 401, { "content-type" => "application/json" }, [ body ] ]
  end
end
