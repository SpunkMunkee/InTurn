class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true
      t.float :purchaseTaxRate

      t.timestamps
    end
  end
end
