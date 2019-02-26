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
    mpan = params[:mpan]
    if mpan && !mpan.blank?
      begin
        path = "/rest/v1/ecoes/mpans?mpanCore=#{mpan}"
        mpans = junifer_get! path
        hash = JSON.parse mpans
        render json: hash['results']
      rescue RestClient::BadRequest => e
        Rails.logger.warn "api#mpans error: #{e.http_body}"
        render json: e.http_body, status: 400
      end
    else
      render json: nil, status: 400
    end
  end

  def mprns
    mprn = params[:mprn]
    if mprn && !mprn.blank?
      begin
        path = "/rest/v1/des/mprns?mprn=#{mprn}"
        mprns = junifer_get! path
        hash = JSON.parse mprns
        render json: hash['results']
      rescue RestClient::BadRequest => e
        Rails.logger.warn "api#mprns error: #{e.http_body}"
        render json: e.http_body, status: 400
      end
    else
      render json: nil, status: 400
    end
  end

  def customer
    number = params[:account_number]; mprn = params[:mprn]; mpan = params[:mpan]
    accounts_path = "/rest/v1/accounts?number=#{number}" if !number.blank?
    accounts_path = "/rest/v1/accounts?MPRN=#{mprn}" if !mprn.blank?
    accounts_path = "/rest/v1/accounts?MPAN=#{mpan}" if !mpan.blank?
    if accounts_path
      begin
        Rails.logger.warn "#{accounts_path}"
        accounts_response = junifer_get! accounts_path
        accounts_hash = JSON.parse accounts_response
        if accounts_hash['results'].count == 1
          customer_link = accounts_hash['results'][0]['links']['customer']
          customer_path = customer_link.match(/(\/rest\/v1.+)$/)[1]
          customer_response = junifer_get! customer_path
          customer_hash = JSON.parse customer_response
          without_links = customer_hash
          without_links.delete("links")
          render json: without_links
        else
          render json: { "numberOfAccounts" => accounts_hash['results'].count }, status: 404
        end
      rescue RestClient::BadRequest => e
        Rails.logger.warn "api#customer error: #{e.http_body}"
        render json: e.http_body, status: 400
      end
    else
      render json: nil, status: 400
    end
  end

  private

    def junifer_get!(path)
      baseurl = "#{ENV['JUNIFER_PROTOCOL']}://#{ENV['JUNIFER_HOSTNAME']}:#{ENV['JUNIFER_PORT']}"
      RestClient.proxy = ENV['QUOTAGUARDSTATIC_URL']
      request_url = "#{baseurl}#{path}"
      response = RestClient::Request.execute( method: :get,
                                              url: request_url,
                                              headers: {'Content-Type' => 'application/json'},
                                              verify_ssl: false,
                                              timeout: 10                                      )
      response.body
    end

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        token == '4e6a3e6b640aa6044df51ad235e85d3b'
      end
    end
end
