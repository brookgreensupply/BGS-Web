class GasPostcode < ApplicationRecord
  self.primary_key = 'postcode'

  def self.lookup(postcode)
    zone =   where("postcode = ?", postcode).first
    zone ||= where("postcode = ?", postcode.split(' ').first).first
    zone ||= where("postcode ILIKE '#{postcode.split(' ').first} %'").first
  end

end
