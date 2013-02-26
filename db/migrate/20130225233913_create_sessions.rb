class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :ip_address
      t.string :user_agent
      t.string :token

      t.timestamps
    end
  end
end
