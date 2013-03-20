class ChangeIpAddressesInSessions < ActiveRecord::Migration
  def up
    change_table :sessions do |t|
      t.column :remote_ip_address, :inet
      t.column :device_ip_address, :inet
      t.remove :ip_address
    end
  end

  def down 
    change_table :sessions do |t|
      t.column :ip_address, :string
      t.remove :remote_ip_address
      t.remove :device_ip_address
    end
  end
end
