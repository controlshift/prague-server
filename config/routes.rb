require 'sidekiq/web'
PragueServer::Application.routes.draw do
  devise_for :users, controllers: { registrations: :users, confirmations: :confirmations }

  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  ActiveAdmin.routes(self)
  get 'config/:id', to: ConfigController.action(:index)

  namespace :api do
    resources :namespaces, controller: 'namespaces', only: [:index, :show] do
      collection do
        get :raised
      end
      resources :charges, only: [:index], controller: 'namespaces/charges'
    end
    resources :tags, controller: 'tags', only: [:index, :show] do
      resources :charges, only: [:index], controller: 'tags/charges'
    end
    resources :charges, controller: 'charges', only: [:index]
    resource :config, controller: 'config', only: [:show]
    resource :code_snippet, controller: 'code_snippet', only: [:show] do
      member do
        get 'parameters'
      end
    end
  end

  resources :orgs, only: [:show, :new, :create, :update], controller: 'organizations', :as => 'organizations' do
    member do
      patch 'toggle'
      put 'deauthorize'
    end
    resource  :settings, only: [:show], controller: 'org/settings'
    resources :crms, only: [:create, :update], controller: 'org/crms'
    resources :invitations, only: [:create], controller: 'org/invitations'
    resources :users, controller: 'org/users'
    resources :charges, controller: 'org/charges'
    resources :tags, controller: 'org/tags' do
      resources :charges, only: [:index], controller: 'org/tags/charges'
    end
    resources :namespaces, controller: 'org/namespaces' do
      collection do
        get :raised
      end
    end
  end

  resources :charges, only: [:create, :destroy]

  get '/auth/:provider/callback', to: 'authentications#create'

  root 'home#index'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["ADMIN_USER"] && password == ENV["ADMIN_PASS"]
  end
  mount Sidekiq::Web => '/sidekiq'
  mount StripeEvent::Engine => '/stripe/event'

end
