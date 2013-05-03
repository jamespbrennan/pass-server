class AddSessionsTable < ActiveRecord::Migration
  def change
    create_table :site_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.integer :pass_session_id
      t.timestamps
    end

    add_index :site_sessions, :session_id
    add_index :site_sessions, :pass_session_id
    add_index :site_sessions, :updated_at
  end
end
