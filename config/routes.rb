Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :travel, only: %i[show update]
  resource :history, only: :show
end
