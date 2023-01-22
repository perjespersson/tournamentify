Rails.application.routes.draw do
  devise_for :users
  root "welcome#index"

  resource :welcome, only: [:index]
  resources :tournaments, only: [:new, :create, :show]
end
