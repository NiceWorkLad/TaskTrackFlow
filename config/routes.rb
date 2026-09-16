Rails.application.routes.draw do
  get "/docs", to: "pages#docs"
  get "/profile", to: "pages#profile"
  get "/dev", to: "pages#dev"
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"

  devise_for :users, controllers: {
  sessions: "users/sessions",
  omniauth_callbacks: "users/omniauth_callbacks"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :tasks

  get "public_tasks", to: "tasks#public_index", as: "public_tasks"

  resources :users, only: [ :show, :index ]

  patch "/settings/username", to: "settings#update_username", as: :settings_username

  root to: "pages#home"

  get "/verify" => "verify#edit", :as => "verify"
  get "/verify" => "verify#new", :as => "new_verify"
  put "/verify" => "verify#update", :as => "update_verify"
  post "/verify" => "verify#create", :as => "create_verify"
end
