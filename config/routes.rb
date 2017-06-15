Rails.application.routes.draw do
  devise_for :users
  resources :users
  root to: 'visitors#index'

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/cms', :sitemap => false
end
