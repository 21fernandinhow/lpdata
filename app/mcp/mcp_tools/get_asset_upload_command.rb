module McpTools
  class GetAssetUploadCommand < Base
    tool_name "get_asset_upload_command"
    title "Build the asset upload command"
    description <<~DESCRIPTION
      Returns a shell command that uploads a local file to LPData. It does not
      transfer any bytes itself: this server is remote and cannot read your
      disk, and a real image sent inline would have to be written out token by
      token.

      Run the returned command as it is, in a shell that already has
      `LPDATA_EMAIL`, `LPDATA_PASSWORD` and optionally `LPDATA_URL` in its
      environment, and that has `jq` installed. The shell expands those
      variables, so the command text never contains the password or the token.
      Do not print, echo or paste the token anywhere.

      The second curl prints the uploaded asset as JSON. Take its `public_url`
      and use it as the `value` of a `hosted_file` Editable Field.
    DESCRIPTION

    input_schema(
      properties: {
        file_path: {
          type: "string",
          description: "Path of the file to upload, on the machine where the command will run."
        }
      },
      required: %w[file_path]
    )

    def self.call(file_path:, server_context: nil)
      text_response(<<~COMMAND)
        FILE=#{shell_quote(file_path)}

        TOKEN=$(curl -s -X POST "${LPDATA_URL:-https://api.lpdata.io}/auth/sign_in" \\
          -H 'Content-Type: application/json' \\
          -d "{\\"user\\":{\\"email\\":\\"$LPDATA_EMAIL\\",\\"password\\":\\"$LPDATA_PASSWORD\\"}}" | jq -r .access_token)

        curl -s -X POST "${LPDATA_URL:-https://api.lpdata.io}/assets" \\
          -H "Authorization: Bearer $TOKEN" -F "asset[file]=@$FILE"
      COMMAND
    end

    # Single quotes so a path with spaces or shell metacharacters survives.
    def self.shell_quote(value)
      "'#{value.to_s.gsub("'", "'\\\\''")}'"
    end
    private_class_method :shell_quote
  end
end
