class GasProduct < ApplicationRecord

  scope :zone, -> zone { where('distribution_zone = ?', zone) }
  scope :usage, -> usage { where('? BETWEEN lower_limit_aq AND upper_limit_aq', usage) }
  scope :spend, -> spend { where('? * 100 / rate BETWEEN lower_limit_aq AND upper_limit_aq', spend) }
  scope :duration, -> years { where('duration = ?', years) }

end
