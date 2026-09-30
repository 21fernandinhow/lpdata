# Drives the MCP endpoint over HTTP the way a client does: one handshake per
# session, then JSON-RPC calls carrying the session id the server issued.
module McpTestHelper
  PROTOCOL_VERSION = "2025-06-18"

  def mcp_connect(email:, password:)
    @mcp_email = email
    @mcp_password = password
    @mcp_session_id = nil

    result = mcp_request("initialize", {
      protocolVersion: PROTOCOL_VERSION,
      capabilities: {},
      clientInfo: { name: "lpdata-test-client", version: "1.0" }
    })

    @mcp_session_id = response.headers["mcp-session-id"]
    mcp_notify("notifications/initialized")
    result
  end

  def mcp_request(method, params = nil, email: @mcp_email, password: @mcp_password)
    @mcp_request_id = (@mcp_request_id || 0) + 1
    body = { jsonrpc: "2.0", id: @mcp_request_id, method: method }
    body[:params] = params if params

    post "/mcp", params: body.to_json, headers: mcp_headers(email: email, password: password)

    response.body.present? ? JSON.parse(response.body) : nil
  end

  def mcp_notify(method, params = nil)
    body = { jsonrpc: "2.0", method: method }
    body[:params] = params if params

    post "/mcp", params: body.to_json, headers: mcp_headers
  end

  def mcp_tools
    mcp_request("tools/list").dig("result", "tools")
  end

  # Returns the tool result envelope: { "content" => [...], "isError" => bool }.
  def mcp_call_tool(name, arguments = {})
    mcp_request("tools/call", { name: name, arguments: arguments }).fetch("result")
  end

  def mcp_tool_text(name, arguments = {})
    mcp_call_tool(name, arguments).dig("content", 0, "text")
  end

  def mcp_tool_json(name, arguments = {})
    JSON.parse(mcp_tool_text(name, arguments))
  end

  private

  def mcp_headers(email: @mcp_email, password: @mcp_password)
    headers = {
      "Content-Type" => "application/json",
      "Accept" => "application/json, text/event-stream"
    }
    headers["X-LPData-Email"] = email if email
    headers["X-LPData-Password"] = password if password
    headers["Mcp-Session-Id"] = @mcp_session_id if @mcp_session_id

    headers
  end
end
