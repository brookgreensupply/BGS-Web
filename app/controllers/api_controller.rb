class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :restrict_access

  def companies
    regno = params[:registration_number]
    coname = params[:company_name]
    company = if regno && !regno.blank?
      $creditsafe.find_company(country_code: "GB", registration_number: regno)
    elsif coname && !coname.blank?
      $creditsafe.find_company(country_code: "GB", company_name: coname)
    else
      nil
    end
    render json: company
  end

  def report
    company_id = params[:company_id]
    company = $creditsafe.company_report(company_id)
    render json: company
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
