require 'sidekiq/web'
PragueServer::Application.routes.draw do
  use_doorkeeper
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'config/:id', to: ConfigController.action(:index)

  namespace :org do
    resources :charges, controller: 'charges'
  end

  namespace :api do
    resources :tags, controller: 'tags', only: [:show]
    resources :charges, controller: 'charges', only: [:index]
    resource :config, controller: 'config', only: [:show]
    resource :code_snippet, controller: 'code_snippet', only: [:show]
  end

  resources :organizations, only: [:show, :update, :new] do
    member do
      patch 'toggle'
      put 'deauthorize'
    end
  end
  resources :charges, only: [:create, :destroy]
  resources :crms, only: [:create, :update]

  get '/auth/:provider/callback', to: 'authentications#create'

  root 'home#index'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["ADMIN_USER"] && password == ENV["ADMIN_PASS"]
  end 
  mount Sidekiq::Web => '/sidekiq'
  mount StripeEvent::Engine => '/stripe/event'

  devise_for :organizations, path_prefix: 'accounts', controllers: { confirmations: 'confirmations' }
end
