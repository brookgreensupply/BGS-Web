module QuotesHelper
  def one_line_addresses_from_junifer_hash(hash)
    results = hash['results'] if hash
    if results
      results.map do |result|
        (1..9).map { |i| result["meteringPointAddressLine#{i}"] }.compact.join(', ')
      end
    else
      []
    end
  end

  def mpans_from_junifer_hash(hash)
    results = hash['results'] if hash
    if results
      results.map do |result|
        result['mpan']
      end
    else
      []
    end
  end

  def mprns_from_junifer_hash(hash)
    results = hash['results'] if hash
    if results
      results.map do |result|
        result['mprn']
      end
    else
      []
    end
  end
end
