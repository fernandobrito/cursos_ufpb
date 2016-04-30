Rails.application.routes.draw do
  root to: 'visitors#index'

  scope '/admin' do
    devise_for :users
  end

  namespace :admin do
    root to: 'users#index'

    resources :users
  end

  namespace :api do
    root to: 'curricula#index'

    resources :curricula, only: [:index, :show]
  end
end
