# Warms the MCP endpoint on the boot thread, and again after each reload in
# development. Building it here rather than on the first request keeps two
# concurrent requests from each building a transport and disagreeing about which
# MCP sessions exist.
Rails.application.config.to_prepare do
  McpEndpoint.instance
end
