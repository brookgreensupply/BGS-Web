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

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/cms', :sitemap => true
end
