class AddServiceIdToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :service_id, :int
  end
end
