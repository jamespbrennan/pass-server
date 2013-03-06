class AddAccessTokenToProver < ActiveRecord::Migration
  def change
    add_column :provers, :access_token, :string
  end
end
