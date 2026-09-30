Rails.application.routes.draw do
  devise_for :users, skip: :all

  post "auth/sign_up", to: "auth/registrations#create"
  post "auth/sign_in", to: "auth/sessions#create"
  delete "auth/sign_out", to: "auth/sessions#destroy"
  post "auth/refresh", to: "auth/tokens#refresh"
  get "auth/me", to: "auth/users#show"

  post "manage/landing_pages", to: "landing_pages#create"
  get "manage/landing_pages", to: "landing_pages#index"
  get "manage/landing_pages/:id", to: "landing_pages#manage_show"
  patch "manage/landing_pages/:id", to: "landing_pages#update"
  delete "manage/landing_pages/:id", to: "landing_pages#destroy"
  get "landing_pages/:public_id", to: "landing_pages#show"

  resources :assets, only: %i[index show create destroy]

  # Resolved per request rather than captured here: routes are not redrawn when a
  # tool file changes, so mounting the object itself would pin the endpoint to
  # classes the reloader has already discarded.
  mount ->(env) { McpEndpoint.instance.call(env) }, at: "/mcp", as: :mcp

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
