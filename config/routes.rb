# config/routes.rb
Rails.application.routes.draw do
  root "sessions#new"

  # Sessões (login/logout)
  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Admin: formulários + templates + turmas
  namespace :admin do
    root to: "formularios#index"
    get "gerenciamento", to: "gerenciamento#index"
    resources :formularios do
      member do
        get :respostas
      end
    end
    resources :templates
    resources :turmas do
      collection do
        get :import_form
        post :import
      end
    end
    get "perfil", to: "perfil#show"
    get "perfil/editar_senha", to: "perfil#edit_password", as: :edit_password
    patch "perfil/editar_senha", to: "perfil#update_password"
  end

  # Respondente: página de formulários disponíveis
  namespace :respondente do
    resources :formularios, only: [ :index, :show ] do
      member do
        post :submit
      end
    end
    get "perfil", to: "perfil#show"
    get "perfil/editar_senha", to: "perfil#edit_password", as: :edit_password
    patch "perfil/editar_senha", to: "perfil#update_password"
  end

  get "admin/templates/new_question/:index",
    to: "admin/templates#new_question",
    as: :new_admin_template_question
end
