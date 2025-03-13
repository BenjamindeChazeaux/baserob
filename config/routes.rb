Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Routes pour le PagesController
  get 'pages/home', to: 'pages#home'
  get 'pages/about', to: 'pages#about'
  get 'pages/contact', to: 'pages#contact'

  # Routes pour le WelcomeController
  get 'welcome', to: 'welcome#index'
  get 'welcome/index'
  get 'welcome/home', to: 'welcome#home'
  get 'welcome/ai_analytics', to: 'welcome#ai_analytics'
  get 'welcome/geo_scoring', to: 'welcome#geo_scoring'
  get 'welcome/website_crawling', to: 'welcome#website_crawling'
  get 'welcome/settings', to: 'welcome#settings'

  # Routes pour d'autres contrôleurs (exemple)
  resources :users do
    resources :posts
  end

  # Modules principaux
  resources :ai_analytics, only: [:index]
  resources :geo_scorings, only: [:index] do
    get "history/:keyword_id", to: "geo_scorings#history", on: :collection
  end
  resources :requests, only: [:index]
  resources :keywords, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Autres routes personnalisées
  get 'dashboard', to: 'dashboard#index'
  get 'profile', to: 'users#show'
  
  # Route pour le QuickStart setup du dashboard client
  post 'dashboard/quick_setup', to: 'dashboard#quick_setup', as: :dashboard_quick_setup

  get 'requests', to: 'requests#index', as: 'requests_index'

  # Route pour les analytics IA
  get 'ai_analytics', to: 'analytics#ai', as: :analytics_ai

end
