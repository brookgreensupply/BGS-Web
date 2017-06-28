class CreateGasProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :gas_products, id: false do |t|
      t.integer  :matrix_id
      t.integer  :duration
      t.string   :distribution_area
      t.string   :rate_name
      t.decimal  :rate, precision: 8, scale: 4
      t.decimal  :standing_charge_rate, precision: 8, scale: 4
      t.timestamps null: false
    end

    add_index :gas_products, :matrix_id, unique: true
    add_index :gas_products, :distribution_area

    create_table :gas_products_upload, id: false do |t|
      t.integer  :matrix_id, null: false
      t.integer  :duration, null: false
      t.string   :distribution_area, null: false
      t.string   :rate_name, null: false
      t.decimal  :rate, precision: 8, scale: 4, null: false
      t.decimal  :standing_charge_rate, precision: 8, scale: 4, null: false
      t.timestamps null: false
    end
  end
end
