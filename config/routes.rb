Rails.application.routes.draw do
  HighVoltage.configure do |config|
    config.home_page = 'home'
  end

  resources :transcripts, only: [:create]

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
