require "rest-client"
RestClient.proxy = ENV["QUOTAGUARDSTATIC_URL"]
$JuniferBaseUrl = "#{ENV['JUNIFER_PROTOCOL']}://#{ENV['JUNIFER_HOSTNAME']}:#{ENV['JUNIFER_PORT']}"
