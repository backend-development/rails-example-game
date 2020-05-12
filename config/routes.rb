Rails.application.routes.draw do
  resources :games
  devise_for :users
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy'
  end
  resources :users

  # dokku deploy checks http://dokku.viewdocs.io/dokku/deployment/zero-downtime-deploys/
  get '/check.txt', to: proc { [200, {}, ['simple_check']] }
  
  root to: 'games#index'
end
