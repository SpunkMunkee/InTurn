class CreateCategoryProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :category_products do |t|
      t.references :Product, null: false, foreign_key: true
      t.references :Category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
