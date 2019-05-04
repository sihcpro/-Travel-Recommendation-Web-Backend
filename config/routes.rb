Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :user, only: %i[create show update destroy]
  resource :travel, only: %i[index create show update destroy]
  # resource :history, only: :show
  resource :comment, only: %i[create show update destroy]

  resources :user_comments, only: :show
  resources :travel_comments, only: :show

  # resources :travel, only: :show
  resources :start, only: :show
  # resources :history, only: :show

  resources :suggestion, only: :show
  resources :favorite, only: :show

  post '/login', to: 'sessions#create', as: 'login'
  post '/logout', to: 'sessions#destroy', as: 'logout'
end
