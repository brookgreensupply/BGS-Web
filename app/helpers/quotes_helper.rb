module QuotesHelper
  def valid_postcode(postcode)
    @@postcode_regexp ||= /^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([AZa-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) [0-9][A-Za-z]{2})$/
    postcode.match @@postcode_regexp
  end

  def mpan_lookup(postcode)
    if valid_postcode(postcode)
      require 'uri'
      junifer_url = ENV['JUNIFER_PROTOCOL'] + "://" + ENV['JUNIFER_HOSTNAME'] + ":" + ENV['JUNIFER_PORT']
      endpoint_url = "/rest/v1/ecoes/mpans?postcode=#{postcode.upcase}"
      request_url = "#{junifer_url}#{endpoint_url}"
      escaped_url = URI.escape(request_url)
      begin
        mpans_json = RestClient::Request.execute( method: :get,
                                                  url: escaped_url,
                                                  verify_ssl: false,
                                                  timeout: 10        )
        JSON.load(mpans_json)
      rescue RestClient::BadRequest => e
        error_json = e.response.body
        JSON.load(error_json)
      end
    end
  end

  def mprn_lookup(postcode)
    if valid_postcode(postcode)
      require 'uri'
      junifer_url = ENV['JUNIFER_PROTOCOL'] + "://" + ENV['JUNIFER_HOSTNAME'] + ":" + ENV['JUNIFER_PORT']
      endpoint_url = "/rest/v1/des/mprns?postcode=#{postcode.upcase}"
      request_url = "#{junifer_url}#{endpoint_url}"
      escaped_url = URI.escape(request_url)
      begin
        mprns_json = RestClient::Request.execute( method: :get,
                                                  url: escaped_url,
                                                  verify_ssl: false,
                                                  timeout: 10        )
        JSON.load(mprns_json)
      rescue RestClient::BadRequest => e
        error_json = e.response.body
        JSON.load(error_json)
      end
    end
  end

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
        result['profileClassId'].to_s.rjust(2, '0') + \
        result['meterTimeswitchCode'].to_s.rjust(3, '0') + \
        result['lineLossFactorClassId'].to_s.rjust(3, '0') + \
        result['mpanCore'].to_s.rjust(13, '0')
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
