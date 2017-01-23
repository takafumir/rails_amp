Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get '/index', to: 'home#index'
  get '/help',  to: 'home#help'
  get '/about', to: 'home#about'

  get '/users/index', to: 'users#index'
  get '/users/show',  to: 'users#show'
end
