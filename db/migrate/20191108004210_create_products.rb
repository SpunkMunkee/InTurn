class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :item
      t.string :description
      t.float :price
      t.integer :stock
      t.float :percentDiscount

      t.timestamps
    end
  end
end
