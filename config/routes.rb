Rails.application.routes.draw do
  # health check route
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Root path
  root "posts#index"

  # Posts と Likes のネストを一つにまとめる
  resources :posts, only: [:index, :show, :create, :update, :destroy] do
    resources :likes, only: [:create, :destroy]
  end
end
