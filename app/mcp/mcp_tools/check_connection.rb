module McpTools
  class CheckConnection < Base
    tool_name "check_connection"
    title "Check the LPData connection"
    description <<~DESCRIPTION
      Returns the LPData account this session is authenticated as, as
      `{ "user": { "id", "email" } }`. Call it first: it proves the credential
      headers reach the server, and it carries the contract every Content
      Document must follow.

      #{ContentDocumentContract::FULL}
    DESCRIPTION

    def self.call(server_context: nil)
      json_response(user: { id: current_user.id, email: current_user.email })
    end
  end
end
