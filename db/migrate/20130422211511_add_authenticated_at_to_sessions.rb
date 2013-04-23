class AddAuthenticatedAtToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :authenticated_at, :timestamp
  end
end
