require 'spec_helper'

describe QuotesHelper do
  describe "#one_line_addresses_from_junifer_hash" do
    before do
      mprn_results = <<MPRNRESULTS
{
  "results": [
    {
      "mprn": "10903408",
      "meteringPointAddressLine1": "KENSINGTON CENTRE",
      "meteringPointAddressLine4": "66",
      "meteringPointAddressLine6": "HAMMERSMITH ROAD",
      "meteringPointAddressLine9": "LONDON",
      "meteringPointPostcode": "W14 8UD",
      "designation": "Industrial",
      "meterSerialNumber": "705225",
      "prepayDetected": false
    },
    {
      "mprn": "8815177407",
      "meteringPointAddressLine2": "SCOTTISH AMICABLE INV MANAGERS LTD",
      "meteringPointAddressLine3": "SUN OIL HOUSE",
      "meteringPointAddressLine4": "80",
      "meteringPointAddressLine6": "HAMMERSMITH ROAD",
      "meteringPointAddressLine9": "LONDON",
      "meteringPointPostcode": "W14 8UD",
      "designation": "Industrial",
      "meterSerialNumber": "335293",
      "prepayDetected": false
    }
  ]
}
MPRNRESULTS
      @results_hash = JSON.parse mprn_results
    end

    it "returns as many addresses as there are results" do
      array = helper.one_line_addresses_from_junifer_hash(@results_hash)
      expect(array.count).to eql(2)
    end

    it "joins all address lines into one, with commas in between" do
      array = helper.one_line_addresses_from_junifer_hash(@results_hash)
      expect(array[1]).to eql('SCOTTISH AMICABLE INV MANAGERS LTD, SUN OIL HOUSE, 80, HAMMERSMITH ROAD, LONDON')
    end

    it "returns empty list if input is nil" do
      array = helper.one_line_addresses_from_junifer_hash({})
      expect(array).to be_empty
    end

    it "returns empty list if input is not right" do
      array = helper.one_line_addresses_from_junifer_hash({})
      expect(array).to be_empty
    end
  end
end
