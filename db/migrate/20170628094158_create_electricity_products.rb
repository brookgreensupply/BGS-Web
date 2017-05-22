class CreateElectricityProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :electricity_products, id: false do |t|
      t.integer  :matrix_id
      t.integer  :profile_class
      t.integer  :duration
      t.string   :distribution_area
      t.string   :rate1_name
      t.decimal  :rate1, precision: 8, scale: 4
      t.string   :rate2_name
      t.decimal  :rate2, precision: 8, scale: 4
      t.decimal  :standing_charge_rate, precision: 8, scale: 4
      t.timestamps null: false
    end

    add_index :electricity_products, :matrix_id, unique: true
    add_index :electricity_products, :distribution_area
    add_index :electricity_products, :profile_class

    create_table :electricity_products_upload, id: false do |t|
      t.integer  :matrix_id, null: false
      t.integer  :profile_class, null: false
      t.integer  :duration, null: false
      t.string   :distribution_area, null: false
      t.string   :rate1_name, null: false
      t.decimal  :rate1, precision: 8, scale: 4, null: false
      t.string   :rate2_name, null: false
      t.decimal  :rate2, precision: 8, scale: 4, null: false
      t.decimal  :standing_charge_rate, precision: 8, scale: 4, null: false
      t.timestamps null: false
    end
  end
end
