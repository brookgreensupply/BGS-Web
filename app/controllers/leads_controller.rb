class LeadsController < ApplicationController
  def electricity
    # expected params are: fullname, company, telephone, postcode, email, spend
    LeadsMailer.email('electricity', filtered_hash(params)).deliver_now
  end

  def gas
    # expected params are: fullname, company, telephone, postcode, email, spend
    LeadsMailer.email('gas', filtered_hash(params)).deliver_now
  end

  private

    def filtered_hash(hash)
      new_hash = {}
      keys_to_remove = ['controller', 'action', 'authenticity_token', 'submit']
      keys_to_copy = hash.keys.reject { |k| keys_to_remove.include? k }
      keys_to_copy.each { |k| new_hash[k] = hash[k] }
      new_hash
    end
end
