class AddProverIdToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :prover_id, :int
  end
end
