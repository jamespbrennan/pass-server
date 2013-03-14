class DropAuthentications < ActiveRecord::Migration
  def up
  	drop_table :authentications
  end

  def down
  	create_table :authentications do |t|
      t.string :ip_address
      t.prover_id :integer
      t.service_id :integer

      t.timestamps
    end
  end
end
