class AddDeviceTypeIdToProver < ActiveRecord::Migration
  def change
    add_column :provers, :device_type_id, :int
  end
end
