Rails.application.routes.draw do
  devise_for :users
  root "welcome#index"

  resource :welcome, only: [:index]
  resource :tournament, only: [:new, :create]
end
