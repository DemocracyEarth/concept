Rails.application.routes.draw do
  resources :users

   get '/singin', to: 'users#singin', as: 'singin'
   get '/', to: 'users#new', as: 'singup'
   post '/auth', to: 'users#login', as: 'authenticated'
   get '/vote', to: 'users#vote', as: 'vote'
   get '/decition', to: 'users#decition', as: 'decition'
   get '/confirm', to: 'users#confirmVote', as: 'confirm'
   get '/logout', to: 'users#logout', as: 'singout'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
