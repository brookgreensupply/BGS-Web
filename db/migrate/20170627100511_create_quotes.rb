class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      t.string   :postcode
      t.string   :product_type
      t.text     :address
      t.string   :mpan
      t.string   :mprn
      t.integer  :usage
      t.integer  :cost
      t.integer  :usage_or_cost_period
      t.json     :presented_products
      t.timestamps null: false
    end

    add_index :quotes, :postcode
  end
end
