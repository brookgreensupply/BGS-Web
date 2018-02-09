class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :restrict_access

  def companies
    regno = params[:registration_number]
    # FIXME: this can raise an exception, e.g. Creditsafe::AccountError
    # $creditsafe.find_company(country_code: "GB", registration_number: regno)
    registration_number = '07495895'
    render json: File.read("#{Rails.root}/public/companies.json")
  end

  def report
    company_id = 'GB003/0/07495895'
    render json: File.read("#{Rails.root}/public/report.json")
  end

  def mpans
    mpan = '038012011050000876352'
    mpans = [{
      pc: '03',
      mtc: '801',
      llfc: '201',
      did: '10',
      uid: '50000876',
      cd: '352',
      address: 'MAIN FRONT SHOP, 51, HIGH STREET, BEDFORD MK40 1RZ',
      postcode: 'MK40 1RZ'
    }]
    render json: mpans
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      token == '4e6a3e6b640aa6044df51ad235e85d3b'
    end
  end
end
