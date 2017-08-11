class GasProduct < ApplicationRecord

  scope :zone, -> zone { where('distribution_zone = ?', zone) }
  scope :usage, -> usage { where('? BETWEEN lower_limit_aq AND upper_limit_aq', usage) }
  scope :duration, -> years { where('duration = ?', years) }

end
