class RenameAccessTokenToTokenInDevices < ActiveRecord::Migration
  def up
    rename_column :devices, :access_token, :token
  end

  def down
    rename_column :devices, :token, :access_token
  end
end
