module McpTools
  class ListAssets < Base
    tool_name "list_assets"
    title "List assets"
    description <<~DESCRIPTION
      Lists the files hosted by LPData for the authenticated account, each with
      its `id`, `filename`, `content_type`, `byte_size` and `public_url`. Put a
      `public_url` in the `value` of a `hosted_file` Editable Field to show the
      file on a landing page.
    DESCRIPTION

    input_schema(properties: {}, required: [])

    def self.call(server_context: nil)
      assets = current_user.assets.map { |asset| AssetSerializer.call(asset, host: Current.base_url) }

      json_response(assets: assets)
    end
  end
end
