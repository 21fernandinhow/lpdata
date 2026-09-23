class AddUniqueIndexToLandingPagesPublicIdentifier < ActiveRecord::Migration[8.0]
  def change
    add_index :landing_pages, :public_identifier, unique: true
  end
end
