class AddUserIdToProver < ActiveRecord::Migration
  def change
    add_column :provers, :user_id, :int
  end
end
