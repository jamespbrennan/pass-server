class RemovePublicKeyFromProver < ActiveRecord::Migration
  def change
  	remove_column :provers, :public_key, :string
  end
end
