module McpTools
  # Shared plumbing for the LPData tools: a JSON body in, a JSON body out, and
  # the model's own error message on the way back. No tool validates, corrects
  # or transforms a document; the model is the only authority.
  class Base < MCP::Tool
    # Distinguishes "the client did not send this argument" from "the client
    # sent null", which an update needs in order to stay partial.
    UNSET = Object.new.freeze

    class << self
      private

      def current_user
        Current.user
      end

      def json_response(payload)
        text_response(JSON.pretty_generate(payload))
      end

      def text_response(text)
        MCP::Tool::Response.new([ { type: "text", text: text } ])
      end

      # Tool errors travel as a tool result flagged isError, not as a raised
      # exception: the SDK replaces the message of a raised exception with a
      # generic one, which would swallow the validation path the agent needs.
      def error_response(text)
        MCP::Tool::Response.new([ { type: "text", text: text } ], error: true)
      end

      def validation_error_response(record)
        error_response(record.errors.full_messages.join("\n"))
      end

      def not_found_response(resource)
        error_response("#{resource} not found")
      end

      # Tool arguments reach us with symbol keys all the way down, while a
      # Content Document is compared against string keys once it is stored.
      # This is a marshalling step, not a transformation of the document.
      def normalize_json(value)
        JSON.parse(JSON.generate(value))
      end

      def given(value)
        !value.equal?(UNSET)
      end
    end
  end
end
