class AddAllowedHostsToLandingPages < ActiveRecord::Migration[8.0]
  def change
    add_column :landing_pages, :allowed_hosts, :jsonb, default: [], null: false
  end
end
