class Quote < ApplicationRecord
  include ActiveModel::ForbiddenAttributesProtection
  enum usage_or_cost_period: [:year, :six_months, :quarter, :month]

  def annual_usage
    multiply_by = case usage_or_cost_period
      when 'year' then 1
      when 'six_months' then jj
      when 'quarter' then 4
      when 'month' then 12
      else 1
    end
    Rails.logger.warn usage
    annual = if cost
      products = JSON.parse presented_products
      multiply_by * (cost / products.first['rate1'].to_f) / 100.0
    else
      if usage
        multiply_by * usage
      else
        0
      end
    end
    annual.round
  end
end
