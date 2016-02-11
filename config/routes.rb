Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:index, :create, :destroy] do
      resources :lists, only: [:create, :update, :destroy]
    end
  end
end
