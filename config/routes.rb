# config/routes.rb
Rails.application.routes.draw do
  root "sessions#new"

  # Informações públicas
  get "about",   to: "home#about"
  get "contact", to: "home#contact"

  # Sessões (login/logout)
  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Dashboards
  namespace :admin do
    get "turmas/index"
    get "turmas/show"
    get "turmas/new"
    get "turmas/create"
    get "turmas/edit"
    get "turmas/update"
    get "turmas/destroy"
    get "templates/index"
    get "templates/show"
    get "templates/new"
    get "templates/create"
    get "templates/edit"
    get "templates/update"
    get "templates/destroy"
    get "formularios/index"
    get "formularios/show"
    get "formularios/new"
    get "formularios/create"
    get "formularios/edit"
    get "formularios/update"
    get "formularios/destroy"
    get "dashboard/index"
    get "dashboard", to: "dashboard#index"
  end

  # Admin: formulários + templates + turmas
  namespace :admin do
    resources :formularios
    resources :templates
    resources :turmas
  end

  # Respondente: página de formulários disponíveis
  namespace :respondente do
    resources :formularios, only: [ :index, :show ]
    get "perfil", to: "perfil#show"
  end
end
