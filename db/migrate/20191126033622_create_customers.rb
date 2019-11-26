class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :firstName
      t.string :lastName
      t.string :email
      t.string :streetAddress
      t.string :postalCode
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
