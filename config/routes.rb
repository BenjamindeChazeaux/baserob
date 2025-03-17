Rails.application.routes.draw do
  get 'resources/index'
  get 'resources/show'
  devise_for :users
  root to: "pages#home"
  #
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
  resources :requests, only: [:index, :create]
  resources :keywords, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Routes pour les ressources (blog GEO)
  resources :resources, only: [:index, :show]
  get 'blog', to: 'resources#index', as: :blog
  get 'blog/:slug', to: 'resources#show', as: :blog_article

  # Autres routes personnalisées
  get 'dashboard', to: 'dashboard#index'
  get 'profile', to: 'users#show'

  # Route pour le QuickStart setup du dashboard client
  post 'dashboard/quick_setup', to: 'dashboard#quick_setup', as: :dashboard_quick_setup

  get 'requests', to: 'requests#index', as: 'requests_index'

  # Route pour les analytics IA
  get 'ai_analytics', to: 'analytics#ai', as: :analytics_ai

  resource :companies, only: [:create, :update]

end
