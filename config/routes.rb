Rails.application.routes.draw do
  HighVoltage.configure do |config|
    config.home_page = 'home'
  end

  resources :transcripts, only: [:create] do
    get 'sample', to: 'transcripts#sample', on: :collection
  end

  get 'stats/students', to: 'stats#students'

  scope '/admin' do
    devise_for :users
  end

  namespace :admin do
    root to: 'users#index'

    resources :users

    resources :students, except: [:new]
    resources :programs, except: [:new]
    resources :courses, except: [:new]
    resources :course_results, except: [:new]
  end

  namespace :api do
    root to: 'curricula#index'

    resources :curricula, only: [:index, :show]
  end
end
