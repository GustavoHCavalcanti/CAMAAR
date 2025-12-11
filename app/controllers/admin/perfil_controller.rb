module Admin
  class PerfilController < ApplicationController
    layout "admin"
    before_action :require_login
    before_action :require_admin

    def show
      @user = current_user
    end

    private

    def require_admin
      redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
    end
  end
end
