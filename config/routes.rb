Rails.application.routes.draw do

  # Root route -- this is temporary until we have better starting point
  root to: "service_requests#index" # change this once we have some better page to start
  
  # User model & route generated via Devise gem
  devise_for :users

  # ServiceRequest model has standard resources routes
  resources :service_requests

  # Manual routes for all the rest
  get "/users", to: "users#index" # Show all users is not part of Devise set of Routes
  
  
end
