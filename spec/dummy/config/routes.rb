Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get '/home/index', to: 'home#index'
  get '/home/help',  to: 'home#help'
  get '/home/about', to: 'home#about'

  resources :users, :only => [:index, :show]
end
