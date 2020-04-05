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

  def meterpoint
    id = params[:id]
    if id && !id.blank?
      begin
        path = "/rest/v1/meterPoints/#{id}"
        meterpoint_response = junifer_get! path
        meterpoint = JSON.parse meterpoint_response
        delete_links meterpoint
        render json: meterpoint
      rescue RestClient::BadRequest => e
        Rails.logger.warn "api#meterpoint error: #{e.http_body}"
        render json: e.http_body, status: 400
      end
    else
      render json: nil, status: 400
    end
  end

  def customer
    number = params[:account_number]; mprn = params[:mprn]; mpan = params[:mpan]; id = params[:id]
    accounts_path = "/rest/v1/uk/accounts?number=#{number}" if !number.blank?
    accounts_path = "/rest/v1/uk/accounts?MPRN=#{mprn}" if !mprn.blank?
    accounts_path = "/rest/v1/uk/accounts?MPAN=#{mpan}" if !mpan.blank?
    if accounts_path
      begin
        accounts_response = junifer_get! accounts_path
        accounts_hash = JSON.parse accounts_response
        if accounts_hash['results'].count == 1
          customer_link = accounts_hash['results'][0]['links']['customer']
          customer_path = customer_link.match(/(\/rest\/v1.+)$/)[1]
          customer_response = junifer_get! customer_path
          customer_hash = JSON.parse customer_response
          delete_links customer_hash
          render json: customer_hash
        else
          render json: { "numberOfAccounts" => accounts_hash['results'].count }, status: 404
        end
      rescue RestClient::BadRequest => e
        Rails.logger.warn "api#customer error: #{e.http_body}"
        render json: e.http_body, status: 400
      end
    elsif id
      begin
        customer_path = "/rest/v1/customer/#{id}"
        customer_response = junifer_get! customer_path
        customer_hash = JSON.parse customer_response
        delete_links customer_hash
        render json: customer_hash
      rescue RestClient::NotFound => e
        Rails.logger.warn "api#customer error: #{e.http_body}"
        render json: e.http_body, status: 400
      end
    else
      render json: nil, status: 400
    end
  end

  def agreements
    number = params[:account_number]; mprn = params[:mprn]; mpan = params[:mpan]
    accounts_path = "/rest/v1/uk/accounts?number=#{number}" if !number.blank?
    accounts_path = "/rest/v1/uk/accounts?MPRN=#{mprn}" if !mprn.blank?
    accounts_path = "/rest/v1/uk/accounts?MPAN=#{mpan}" if !mpan.blank?
    if accounts_path
      begin
        accounts_response = junifer_get! accounts_path
        accounts_hash = JSON.parse accounts_response
        actives = accounts_hash['results'].reject{|a| a['cancelledDttm'] || a['closedDttm']}
        if actives.count == 1
          account_id = actives[0]['id']
          agreements_path = "/rest/v1/accounts/#{account_id}/agreements"
          agreements_response = junifer_get! agreements_path
          agreements_hash = JSON.parse agreements_response
          delete_links agreements_hash
          render json: agreements_hash['results']
        else
          render json: { "numberOfAccounts" => actives.count }, status: 404
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

    def delete_links(hash)
      p = proc do |*args|
        k = args.first; v = args.last
        v.delete_if(&p) if v.respond_to? :delete_if
        k == 'links'
      end
      hash.delete_if(&p)
    end

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        token == '4e6a3e6b640aa6044df51ad235e85d3b'
      end
    end
end
