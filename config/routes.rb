Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:index, :create, :destroy] do
      resources :lists, only: [:create, :update, :destroy] do
        resources :items, only: [:create, :update, :destroy]
      end
    end
  end
end
