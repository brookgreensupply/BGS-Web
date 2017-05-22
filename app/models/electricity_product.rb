class ElectricityProduct < ApplicationRecord

  scope :area, -> code { where("distribution_area LIKE '? %'", code) }
  scope :profile_class, -> class_id { where('profile_class = ?', class_id) }
  scope :duration, -> years { where('duration = ?', years) }

end
