Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy'
  end
  resources :users
  get 'static/home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static#home'
end
