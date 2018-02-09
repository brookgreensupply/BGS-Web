require 'creditsafe'

username = ENV['CREDITSAFE_USERNAME']
password = ENV['CREDITSAFE_PASSWORD']
loglevel = :debug

$creditsafe = Creditsafe::Client.new(username: username, \
                                     password: password, \
                                     environment: :test, \
                                     log_level: loglevel   )
