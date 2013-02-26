class AddManufacturerToDeviceTypes < ActiveRecord::Migration
  def change
    add_column :device_types, :manufacturer, :string
  end
end
