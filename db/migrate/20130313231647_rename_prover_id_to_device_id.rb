class RenameProverIdToDeviceId < ActiveRecord::Migration
  def change
  	rename_column :device_accounts, :prover_id, :device_id
  end
end
