class CreateProvinces < ActiveRecord::Migration[6.0]
  def change
    create_table :provinces do |t|
      t.string :province
      t.float :gst
      t.float :hst
      t.float :pst
      t.float :qst

      t.timestamps
    end
  end
end
