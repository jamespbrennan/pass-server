class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.string :access_token
      t.string :allowed_ip_addresses, :array => true

      t.timestamps
    end
  end
end
