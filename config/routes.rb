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

  # Admin: formulários + templates + turmas
  namespace :admin do
    root to: "formularios#index"
    get "gerenciamento", to: "gerenciamento#index"
    resources :formularios
    resources :templates
    resources :turmas
    get "perfil", to: "perfil#show"
  end

  # Respondente: página de formulários disponíveis
  namespace :respondente do
    resources :formularios, only: [ :index, :show ]
    get "perfil", to: "perfil#show"
  end

  get "admin/templates/new_question/:index",
    to: "admin/templates#new_question",
    as: :new_admin_template_question
end
