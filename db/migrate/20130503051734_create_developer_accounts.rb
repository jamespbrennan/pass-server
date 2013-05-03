class CreateDeveloperAccounts < ActiveRecord::Migration
  def change
    create_table :developer_accounts do |t|
      t.references :service
      t.references :user
      t.boolean :is_admin

      t.timestamps
    end
  end
end
