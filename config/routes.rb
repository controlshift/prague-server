require 'sidekiq/web'
PragueServer::Application.routes.draw do
  devise_for :users, controllers: { registrations: :users, confirmations: :confirmations }

  use_doorkeeper do
  end

  get 'config/:id', to: ConfigController.action(:index)

  namespace :api do
    resources :webhook_endpoints, controller: 'webhook_endpoints', only: [:index, :create]
    resources :namespaces, controller: 'namespaces', only: [:index, :show] do
      member do
        get :history
        get :raised
      end

      resources :charges, only: [:index], controller: 'namespaces/charges'
    end
    resources :tags, controller: 'tags', only: [:index, :show] do
      member do
        get :history
      end
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
    resource  :settings, only: [:show], controller: 'org/settings' do
      resources :applications, only: [:index], controller: 'org/settings/applications'
      resource :stripe, only: [:show], controller: 'org/settings/stripe'
      resource :crm, controller: 'org/settings/crm' do
        member do
          get 'test'
        end
        resources :import_stubs, controller: 'org/settings/crm/import_stubs'
      end
    end
    resources :invitations, only: [:create], controller: 'org/invitations'
    resources :users, controller: 'org/users'
    resources :charges, controller: 'org/charges', only: [:show, :index]
    resources :tags, controller: 'org/tags' do
      resources :charges, only: [:index], controller: 'org/tags/charges'
    end
    resources :namespaces, controller: 'org/namespaces' do
      resources :tags, controller: 'org/namespaces/tags'
      collection do
        get :raised
      end
    end
  end

  resources :charges, only: [:create, :destroy]

  get '/auth/:provider/callback', to: 'authentications#create'

  root 'home#index'

  namespace :admin do
    get '/', to: 'admin#index'
    get '/error', to: 'admin#error'
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web, at: '/sidekiq'
      mount Blazer::Engine, at: '/blazer'
      mount PgHero::Engine, at: '/pghero'
      ActiveAdmin.routes(self)

    end
  end

  mount StripeEvent::Engine => '/stripe/event'

end
