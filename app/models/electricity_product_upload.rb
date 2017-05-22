class ElectricityProductUpload < ApplicationRecord
  self.table_name = 'electricity_products_upload'

  def self.start(csv_data)
    ActiveRecord::Base.connection.execute("TRUNCATE electricity_products_upload RESTART IDENTITY")
    CSV.parse(csv_data, headers: true) do |row|
      ElectricityProductUpload.create!(
        matrix_id: row['Matrix Identifier'],
        profile_class: row['PC'],
        duration: row['Duration (Years)'],
        distribution_area: row['Distribution Area'],
        rate1_name: row['Product'],
        rate1: row['Unit Rate 1'],
        rate2_name: row['Rate Name 2'],
        rate2: row['Unit Rate 2'],
        standing_charge_rate: row['Standing Charge']
      )
    end
  end

  def self.finish
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute("TRUNCATE electricity_products RESTART IDENTITY")
      ActiveRecord::Base.connection.execute("INSERT INTO electricity_products SELECT * FROM electricity_products_upload")
      if ElectricityProductUpload.count != ElectricityProduct.count
        raise "row counts of ElectricityProductUpload and ElectricityProduct do not match"
      end
    end
  end
end
