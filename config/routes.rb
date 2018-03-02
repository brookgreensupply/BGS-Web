require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :users
  root to: 'visitors#index'

  get "/help", to: "visitors#help"
  post "/help/search", to: "visitors#help_search", as: 'help_search'

  post "/email/leads/electricity", to: "leads#electricity"
  post "/email/leads/gas", to: "leads#gas"

  resources :quotes
  get "/quotes/new/not-a-small-business", to: "quotes#sorry", as: :not_a_small_business

  get '/switch-supplier', to: redirect('/cms/switching-to-brook-green-supply', status: 301)
  get '/contact-our-energy-team', to: redirect('/cms/contact', status: 301)
  get '/about', to: redirect('/cms/about', status: 301)
  get '/electricity-and-gas-supply-careers', to: redirect('/cms/bgs-careers', status: 301)
  get '/energy-brokers-and-consultants', to: redirect('/cms/consultants', status: 301)
  get '/our-origins', to: redirect('/cms/about', status: 301)
  get '/faq', to: redirect('/cms/business-support/faq', status: 301)

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

  get '/api/v1/companies', to: "api#companies"
  get '/api/v1/report', to: "api#report"
  get '/api/v1/mpans', to: "api#mpans"
  get '/api/v1/mprns', to: "api#mprns"

  # proxy Junifer API calls
  get '/junifer/:request', to: "junifer#proxy", request: /[\/a-zA-z0-9]+/
  post '/junifer/:request', to: "junifer#proxy", request: /[\/a-zA-z0-9]+/

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/cms', :sitemap => true
end
