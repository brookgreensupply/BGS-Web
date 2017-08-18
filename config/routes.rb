require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :users
  root to: 'visitors#index'

  get "/graphics/hero", to: "graphics#hero", format: :svg
  get "/graphics/hero/gas", to: "graphics#hero_gas", format: :svg
  get "/graphics/hero/electric", to: "graphics#hero_electric", format: :svg

  get "/help", to: "visitors#help"
  post "/help/search", to: "visitors#help_search", as: 'help_search'

  post "/email/leads/electricity", to: "leads#electricity"
  post "/email/leads/gas", to: "leads#gas"

  resources :quotes

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
