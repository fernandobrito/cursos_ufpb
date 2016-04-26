Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users
  resources :users

  namespace :api do
    root to: 'curricula#index'

    resources :curricula, only: [:index, :show]
  end
end
