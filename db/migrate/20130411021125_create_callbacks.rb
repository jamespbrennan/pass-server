class CreateCallbacks < ActiveRecord::Migration
  def change
    create_table :callbacks do |t|
      t.string :address
      t.references :callback_type
      t.references :service

      t.timestamps
    end
  end
end
