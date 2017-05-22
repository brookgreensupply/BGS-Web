class AddGasPostcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :gas_postcodes, id: false do |t|
      t.string   :postcode
      t.string   :zone
      t.timestamps null: false
    end

    add_index :gas_postcodes, :postcode, unique: true
    add_index :gas_postcodes, :zone
  end
end
