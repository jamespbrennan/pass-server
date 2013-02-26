class AddServiceIdToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :service_id, :int
  end
end
