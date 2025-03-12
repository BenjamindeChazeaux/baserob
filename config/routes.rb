Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome/show'
  get 'home/index'
  get 'home/show'
  get 'company_ai_providers/index'
  get 'company_ai_providers/show'
  get 'company_ai_providers/new'
  get 'company_ai_providers/create'
  get 'company_ai_providers/edit'
  get 'company_ai_providers/update'
  get 'company_ai_providers/destroy'
  get 'ai_providers/index'
  get 'ai_providers/show'
  get 'ai_providers/new'
  get 'ai_providers/create'
  get 'ai_providers/edit'
  get 'ai_providers/update'
  get 'ai_providers/destroy'
  get 'geo_scorings/index'
  get 'geo_scorings/show'
  get 'geo_scorings/update'
  get 'keywords/index'
  get 'keywords/show'
  get 'keywords/new'
  get 'keywords/create'
  get 'keywords/edit'
  get 'keywords/update'
  get 'keywords/destroy'
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/create'
  get 'users/edit'
  get 'users/update'
  get 'users/destroy'
  get 'companies/index'
  get 'companies/show'
  get 'companies/new'
  get 'companies/create'
  get 'companies/edit'
  get 'companies/update'
  get 'companies/destroy'
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
  resources :geo_scoring, only: [:index]
  get 'geo_scoring', to: 'geo_scoring#index', as: 'geo_scoring'

  # Autres routes personnalisées
  get 'dashboard', to: 'dashboard#index'
  get 'profile', to: 'users#show'
  resources :geo_scorings, only: [:new, :create, :show]
end
