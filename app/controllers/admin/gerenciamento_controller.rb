module Admin
  class GerenciamentoController < ApplicationController
    layout "admin"
    before_action :require_login
    before_action :require_admin

    def index
    end

    private

    def require_admin
      redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
    end
  end
end
