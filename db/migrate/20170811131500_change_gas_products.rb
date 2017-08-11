class ChangeGasProducts < ActiveRecord::Migration[5.0]
  def change
    drop_table :gas_products
    create_table :gas_products, id: false do |t|
      t.integer  :matrix_id
      t.string   :end_user_category
      t.string   :distribution_zone
      t.string   :exit_zone
      t.integer  :lower_limit_aq
      t.integer  :upper_limit_aq
      t.integer  :estimated_aq
      t.string   :broker
      t.date     :start_date
      t.date     :end_date
      t.integer  :duration
      t.decimal  :rate, precision: 8, scale: 4
      t.decimal  :standing_charge_rate, precision: 8, scale: 4
      t.timestamps null: false
    end

    add_index :gas_products, :matrix_id, unique: true
    add_index :gas_products, :distribution_zone

    drop_table :gas_products_upload
    create_table :gas_products_upload, id: false do |t|
      t.integer  :matrix_id
      t.string   :end_user_category
      t.string   :distribution_zone
      t.string   :exit_zone
      t.integer  :lower_limit_aq
      t.integer  :upper_limit_aq
      t.integer  :estimated_aq
      t.string   :broker
      t.date     :start_date
      t.date     :end_date
      t.integer  :duration
      t.decimal  :rate, precision: 8, scale: 4
      t.decimal  :standing_charge_rate, precision: 8, scale: 4
      t.timestamps null: false
    end
  end
end
