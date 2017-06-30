Rails.application.routes.draw do
  devise_for :users
  resources :users
  root to: 'visitors#index'

  resources :quotes

  namespace :admin do
    get 'features', to: "feature_flipper#index", as: :features_admin
    put 'features/:feature/flip', to: "feature_flipper#flip", as: :feature_flip
  end

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/cms', :sitemap => false
end
