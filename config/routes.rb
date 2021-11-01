Rails.application.routes.draw do
  resources :members, only: [:index, :show, :create]
  resources :friendships, only: :create
end
