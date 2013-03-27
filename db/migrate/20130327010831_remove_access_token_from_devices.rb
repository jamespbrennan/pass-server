class RemoveAccessTokenFromDevices < ActiveRecord::Migration
  def change
    remove_column :devices, :access_token, :string
  end
end
