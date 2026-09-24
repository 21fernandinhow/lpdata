Rails.application.routes.draw do
  devise_for :users, skip: :all

  post "auth/sign_up", to: "api/v1/auth/registrations#create"
  post "auth/sign_in", to: "api/v1/auth/sessions#create"
  delete "auth/sign_out", to: "api/v1/auth/sessions#destroy"
  post "auth/refresh", to: "api/v1/auth/tokens#refresh"
  get "auth/me", to: "api/v1/auth/users#show"

  post "landing_pages", to: "api/v1/landing_pages#create"
  get "manage/landing_pages", to: "api/v1/landing_pages#index"
  get "manage/landing_pages/:id", to: "api/v1/landing_pages#manage_show"
  patch "manage/landing_pages/:id", to: "api/v1/landing_pages#update"
  delete "manage/landing_pages/:id", to: "api/v1/landing_pages#destroy"
  get "landing_pages/:public_id", to: "api/v1/landing_pages#show"

  scope "api/v1", module: "api/v1" do
    resources :assets, only: %i[index show create destroy]
  end

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
