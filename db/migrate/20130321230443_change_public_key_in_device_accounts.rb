class ChangePublicKeyInDeviceAccounts < ActiveRecord::Migration
  def up
    change_column :device_accounts, :public_key, :text
  end

  def down 
    change_column :device_accounts, :public_key, :string
  end
end
