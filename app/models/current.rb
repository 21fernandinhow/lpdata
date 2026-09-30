# Carries the identity and the request facts the MCP tools need. The MCP
# transport is a single Rack app shared by every session, so a tool cannot be
# handed the caller through the server context; it reads it from here.
class Current < ActiveSupport::CurrentAttributes
  attribute :user, :base_url, :ip_address
end
