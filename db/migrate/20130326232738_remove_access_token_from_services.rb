class RemoveAccessTokenFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :access_token, :string
  end
end
