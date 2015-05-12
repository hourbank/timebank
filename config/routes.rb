Rails.application.routes.draw do

  # Root route -- this is temporary until we have better starting point
  root to: "site#index" # change this once we have some better page to start
  
  # User model & route generated via Devise gem
  devise_for :users

  # ServiceRequest model has standard resources routes
  resources :service_requests

  # Manual routes for all the rest
  get "/about", to: "site#about"
  get "/contact", to: "site#contact"

  # show all users
  get "/users", to: "users#index" 

  # show current user's private account page
  get "/users/account", to: "users#account"

  # show public profile page of specific user
  get "/users/:id", to: "users#show", as: "user"

  # Also need post/get routes for edit view of users#account

  get "/exchanges/:id/create", to: "exchanges#proposal_by_provider", as: 'create_exchange'
  get "/exchanges/:id", to: "exchanges#show", as: 'exchange'
  get "/exchanges/:id/accept", to: "exchanges#accept_exchange", as: 'accept_exchange'
  
end
