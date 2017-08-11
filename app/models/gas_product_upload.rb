class GasProductUpload < ApplicationRecord
  self.table_name = 'gas_products_upload'

  def self.start(csv_data)
    ActiveRecord::Base.connection.execute("TRUNCATE gas_products_upload RESTART IDENTITY")
    CSV.parse(csv_data, headers: true) do |row|
      start_date = Date.parse row['Start Date']
      end_date = Date.parse row['End Date']
      GasProductUpload.create!(
        matrix_id: row['Identifier'],
        end_user_category: row['End User Category'],
        distribution_zone: row['Local Distribution Zone'],
        exit_zone: row['Exit Zone'],
        lower_limit_aq: row['AQ Band Lower'],
        upper_limit_aq: row['AQ Band Upper'],
        estimated_aq: row['AQ Estimate'],
        broker: row['Broker'],
        start_date: start_date,
        end_date: end_date,
        duration: ((end_date - start_date).to_i / 365.0).round,
        rate: row['Unit Rate'],
        standing_charge_rate: row['Standing Charge']
      )
    end
  end

  def self.finish
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute("TRUNCATE gas_products RESTART IDENTITY")
      ActiveRecord::Base.connection.execute("INSERT INTO gas_products SELECT * FROM gas_products_upload")
      if GasProductUpload.count != GasProduct.count
        raise "row counts of GasProductUpload and GasProduct do not match"
      end
    end
  end
end
