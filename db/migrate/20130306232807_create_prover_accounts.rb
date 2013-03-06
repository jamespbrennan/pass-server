class CreateProverAccounts < ActiveRecord::Migration
  def change
    create_table :prover_accounts do |t|
      t.string :public_key
      t.integer :prover_id
      t.integer :service_id

      t.timestamps
    end
  end
end
