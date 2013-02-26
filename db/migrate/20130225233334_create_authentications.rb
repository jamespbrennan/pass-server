class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :ip_address

      t.timestamps
    end
  end
end
