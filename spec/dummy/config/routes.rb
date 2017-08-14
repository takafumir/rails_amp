Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get '/home/index', to: 'home#index'
  get '/home/help',  to: 'home#help'
  get '/home/about', to: 'home#about'
  namespace :admin do
    resources :sessions
    resources :users, :only => [:index, :show]
  end
  resources :users, :only => [:index, :show] do
    collection do
      get :trailing_slash
    end
  end
end
