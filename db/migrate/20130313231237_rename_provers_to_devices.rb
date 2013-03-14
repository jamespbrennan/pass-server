class RenameProversToDevices < ActiveRecord::Migration
  def change
    rename_table :provers, :devices
    rename_table :prover_accounts, :device_accounts
  end
end
