require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :users

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :admin do
    get 'features', to: "feature_flipper#index", as: :features_admin
    put 'features/:feature/flip', to: "feature_flipper#flip", as: :feature_flip
    resources :products
    put 'products/electricity/prices', to: "products#update_electricity_prices", as: :new_electricity_prices
    put 'products/gas/prices', to: "products#update_gas_prices", as: :new_gas_prices
  end

  get '/v1/companies', to: "api#companies"
  get '/v1/report', to: "api#report"
  get '/v1/mpans', to: "api#mpans"
  get '/v1/mprns', to: "api#mprns"
  get '/v1/meterpoint', to: "api#meterpoint"
  get '/v1/customer', to: "api#customer"
  get '/v1/agreements', to: "api#agreements"

  # proxy Junifer API calls
  get '/junifer/:request', to: "junifer#proxy", request: /[\/a-zA-z0-9]+/
  post '/junifer/:request', to: "junifer#proxy", request: /[\/a-zA-z0-9]+/

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/cms', :sitemap => true
end
