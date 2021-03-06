class JuniferController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :restrict_access

  def proxy
    baseurl = "#{ENV['JUNIFER_PROTOCOL']}://#{ENV['JUNIFER_HOSTNAME']}:#{ENV['JUNIFER_PORT']}"
    RestClient.proxy = ENV['QUOTAGUARDSTATIC_URL']
    request_url = "#{baseurl}/#{request.fullpath.gsub(/^\/junifer\//,'')}"
    payload = request.body unless request.raw_post.empty?
    # TODO: endpoint whitelist/blacklist
    begin
      response = RestClient::Request.execute( method: request.method,
                                              url: request_url,
                                              payload: payload,
                                              headers: {'Content-Type' => 'application/json'},
                                              verify_ssl: false,
                                              timeout: 10                                      )
      render json: response.body
    rescue RestClient::BadRequest => e
      Rails.logger.warn "junifer#proxy error: #{e.http_body}"
      render json: e.http_body, status: 400
    end
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      token == ENV.fetch('API_AUTH_KEY_JUNIFER') || token == ENV.fetch('NEW_API_AUTH_KEY_JUNIFER')
    end
  end
end
