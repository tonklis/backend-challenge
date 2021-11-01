Rails.application.routes.draw do
  resources :members, only: [:index, :show, :create] do
    member do
      # needs topic as query parameter
      # Eg: members/:id/search?topic=:topic
      get :search
    end
  end
  resources :friendships, only: :create
end
