require 'sidekiq/web'
PragueServer::Application.routes.draw do

  resources :organizations, only: [:show, :update, :new]
  resources :charges, only: [:create, :destroy]
  resources :crms, only: [:create, :update]

  get '/auth/:provider/callback', to: 'authentications#create'

  root 'organizations#new'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["ADMIN_USER"] && password == ENV["ADMIN_PASS"]
  end 
  mount Sidekiq::Web => '/sidekiq'

  devise_for :organizations, path_prefix: 'accounts', controllers: { confirmations: 'confirmations' }
end
