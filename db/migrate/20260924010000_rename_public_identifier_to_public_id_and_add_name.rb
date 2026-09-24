class RenamePublicIdentifierToPublicIdAndAddName < ActiveRecord::Migration[8.0]
  def change
    rename_column :landing_pages, :public_identifier, :public_id
    change_column :landing_pages, :public_id, :bigint, using: "public_id::bigint", null: false
    add_column :landing_pages, :name, :string, null: false, default: ""

    remove_index :landing_pages, :public_id
    add_index :landing_pages, :public_id, unique: true

    reversible do |direction|
      direction.up do
        execute "CREATE SEQUENCE landing_pages_public_id_seq START 1"
        execute <<~SQL
          SELECT setval(
            'landing_pages_public_id_seq',
            COALESCE((SELECT MAX(public_id) FROM landing_pages), 1),
            true
          )
        SQL
        change_column_default :landing_pages, :public_id, from: nil, to: -> { "nextval('landing_pages_public_id_seq')" }
      end

      direction.down do
        execute "DROP SEQUENCE landing_pages_public_id_seq"
      end
    end
  end
end
