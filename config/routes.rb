Rails.application.routes.draw do
  resources :payers
  resources :transactions
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  

  post '/login', to: 'session#create'
  post '/signup', to: 'users#create'
  delete '/logout', to: 'session#destroy'
  get '/auth', to: 'users#show'



  get '/balance', to: 'balance#balance'

  post '/spend', to: 'spend#spend'

end
