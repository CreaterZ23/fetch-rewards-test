Rails.application.routes.draw do
  resources :payers
  resources :transactions
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/hello', to: 'application#hello_world'

  post '/login', to: 'session#create'
  post '/signup', to: 'users#create'
  delete '/logout', to: 'session#destroy'
  get '/auth', to: 'users#show'

  get '/balance', to: 'transactions#balance'

  post '/spend', to: 'transactions#spend'
end
