Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :user
  resource :travel, as: :show
  resources :travel, only: %i[show]
  resources :start, only: %i[show]
  resource :history, only: :show
  post '/login', to: 'sessions#create', as: 'login'
  post '/logout', to: 'sessions#destroy', as: 'logout'
end
