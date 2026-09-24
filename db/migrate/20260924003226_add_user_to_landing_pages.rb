class AddUserToLandingPages < ActiveRecord::Migration[8.0]
  def change
    add_reference :landing_pages, :user, null: false, foreign_key: true
  end
end
