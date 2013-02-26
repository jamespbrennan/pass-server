class CreateProvers < ActiveRecord::Migration
  def change
    create_table :provers do |t|
      t.string :public_key

      t.timestamps
    end
  end
end
