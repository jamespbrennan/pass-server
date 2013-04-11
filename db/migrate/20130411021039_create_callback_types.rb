class CreateCallbackTypes < ActiveRecord::Migration
  def change
    create_table :callback_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
