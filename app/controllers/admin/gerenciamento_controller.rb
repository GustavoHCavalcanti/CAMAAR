# Namespace de controllers administrativos para páginas de gerenciamento.
module Admin
  class GerenciamentoController < ApplicationController
    layout "admin"
    before_action :require_login
    before_action :require_admin

    # Tela principal de gestão administrativa (dashboard).
    # @return [void]
    def index
    end

    private

    # Restringe acesso a administradores.
    # @return [void]
    # @side_effect Redireciona com alerta quando não admin
    def require_admin
      redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
    end
  end
end
