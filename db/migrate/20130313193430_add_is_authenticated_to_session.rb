class AddIsAuthenticatedToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :is_authenticated, :boolean
  end
end
