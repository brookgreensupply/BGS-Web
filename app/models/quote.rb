class Quote < ApplicationRecord
  include ActiveModel::ForbiddenAttributesProtection
  enum usage_or_cost_period: [:year, :six_months, :quarter, :month]
end
