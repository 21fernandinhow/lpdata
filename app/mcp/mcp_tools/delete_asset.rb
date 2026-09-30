module McpTools
  class DeleteAsset < Base
    tool_name "delete_asset"
    title "Delete an asset"
    description <<~DESCRIPTION
      Deletes a file hosted by LPData for the authenticated account. Any
      `hosted_file` Editable Field still pointing at its `public_url` keeps the
      dead URL: LPData does not rewrite Content Documents.
    DESCRIPTION

    input_schema(
      properties: {
        id: { type: "integer", description: "Id of the asset, as list_assets reports it." }
      },
      required: %w[id]
    )

    def self.call(id:, server_context: nil)
      asset = current_user.assets.find_by(id: id)
      return not_found_response("Asset") unless asset

      asset.destroy!

      json_response(deleted: true, id: asset.id)
    end
  end
end
