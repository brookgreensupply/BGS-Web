class JuniferController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :restrict_access

  def proxy
    baseurl = "#{ENV['JUNIFER_PROTOCOL']}://#{ENV['JUNIFER_HOSTNAME']}:#{ENV['JUNIFER_PORT']}"
    RestClient.proxy = ENV['QUOTAGUARDSTATIC_URL']
    request_url = "#{baseurl}/#{request.fullpath.gsub(/^\/junifer\//,'')}"
    payload = request.body unless request.raw_post.empty?
    # FIXME: needs auth, endpoint whitelist/blacklist
    response = RestClient::Request.execute( method: request.method,
                                            url: request_url,
                                            payload: payload,
                                            headers: {'Content-Type' => 'application/json'},
                                            verify_ssl: false,
                                            timeout: 10                                      )
    render json: response.body
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      token == '8c87144c18008cb9ec53dc4f434c7a76'
    end
  end
end
