# Builds the Asset representation, including the public URL, shared by the HTTP
# controller and the MCP tools.
class AssetSerializer
  def self.call(asset, host:)
    {
      id: asset.id,
      user_id: asset.user_id,
      filename: asset.file.blob.filename.to_s,
      content_type: asset.file.blob.content_type,
      byte_size: asset.file.blob.byte_size,
      public_url: Rails.application.routes.url_helpers.rails_blob_url(
        asset.file,
        host: host,
        only_path: false
      )
    }
  end
end
