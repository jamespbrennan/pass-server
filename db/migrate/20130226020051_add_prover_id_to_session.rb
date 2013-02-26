class AddProverIdToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :prover_id, :int
  end
end
