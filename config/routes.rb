require 'sidekiq/web'
PragueServer::Application.routes.draw do

  resources :organizations, only: [:create, :new, :show]
  resources :charges, only: [:create, :destroy]

  get '/auth/:provider/callback', to: 'organizations#create'

  root 'organizations#new'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["ADMIN_USER"] && password == ENV["ADMIN_PASS"]
  end 
  mount Sidekiq::Web => '/sidekiq'

  devise_for :organizations
  devise_scope :organizations do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
end
