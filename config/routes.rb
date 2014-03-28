require 'sidekiq/web'
PragueServer::Application.routes.draw do

  resources :organizations, only: [:create, :new, :show]
  resources :charges, only: [:create, :destroy, :index]

  get '/auth/:provider/callback', to: 'organizations#create'

  root 'organizations#new'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["ADMIN_USER"] && password == ENV["ADMIN_PASS"]
  end 
  mount Sidekiq::Web => '/sidekiq'

  delete 'sign_out', to: 'sessions#destroy'

  devise_for :organizations
end
