class AddNameToProver < ActiveRecord::Migration
  def change
    add_column :provers, :name, :string
  end
end
