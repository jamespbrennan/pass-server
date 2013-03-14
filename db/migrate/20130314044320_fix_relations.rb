class FixRelations < ActiveRecord::Migration
  def up
	remove_column :devices, :user_id
	add_reference :devices, :user, index: true

	remove_column :device_accounts, :device_id
	remove_column :device_accounts, :service_id
	add_reference :device_accounts, :device, index: true
	add_reference :device_accounts, :service, index: true

	remove_column :sessions, :prover_id
	remove_column :sessions, :service_id
	add_reference :sessions, :device, index: true
	add_reference :sessions, :service, index: true
  end

  def down
	add_column :devices, :user_id, :integer
	remove_reference :devices, :user

	add_column :device_accounts, :device_id, :integer
	add_column :device_accounts, :service_id, :integer
	remove_reference :device_accounts, :device
	remove_reference :device_accounts, :service

	add_column :sessions, :device_id, :integer
	add_column :sessions, :service_id, :integer
	remove_reference :sessions, :device
	remove_reference :sessions, :service
  end
end
