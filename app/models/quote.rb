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
    annual = if cost
      products = JSON.parse presented_products
      p = products.first
      annual_cost_per_kwh = p['rate1'].to_f / 100.0
      annual_standing_charge = 365 * p['standing_charge'].to_f
      0.96*((multiply_by * cost/p['duration'].to_f) - annual_standing_charge)/annual_cost_per_kwh
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
