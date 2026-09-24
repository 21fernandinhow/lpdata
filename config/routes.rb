Rails.application.routes.draw do
  devise_for :users, skip: :all

  post "api/v1/auth/sign_up", to: "api/v1/auth/registrations#create"
  post "api/v1/auth/sign_in", to: "api/v1/auth/sessions#create"
  delete "api/v1/auth/sign_out", to: "api/v1/auth/sessions#destroy"
  post "api/v1/auth/refresh", to: "api/v1/auth/tokens#refresh"
  get "api/v1/auth/me", to: "api/v1/auth/users#show"

  get "api/v1/landing_pages/:public_identifier", to: "api/v1/landing_pages#show"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
