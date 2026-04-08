Rails.application.routes.draw do
  mount GoodJob::Engine => "good_job"
  # POST /pay/webhooks/stripe
  mount Pay::Engine, at: "/pay", as: "pay_engine"

  constraints StoreSubdomain do
    root "stores#show", as: :store_root
    resources :line_items, only: [:create, :destroy, :update]
    resource  :cart,       only: [:show, :destroy]
  end
  
  resource :onboardings, path: "get-started", only: [ :show, :create ]
  resources :passwords, param: :token

  namespace :authentication, path: "", as: "" do
    resource :session, only: [ :new, :create, :destroy ], path: "login", path_names: { new: "/" }
    resources :users, only: [ :new, :create ], path: "register", path_names: { new: "/" }
  end

  namespace :admin, path: "dashboard" do
    root "dashboards#index"
    resources :subscriptions, only: [:new, :create, :destroy] do
      patch :resume, on: :member
    end
    get  "/billing",        to: "billing#show"
    post "/billing/portal", to: "billing#portal"
    resources :products, only: [ :new, :create, :edit, :update ] do 
      member do
        patch :toggle_active
      end
    end
    get "customize", to: "dashboards#edit", as: :customize
    patch "customize", to: "dashboards#update"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
