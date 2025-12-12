# Namespace de controllers administrativos, controlando ações de perfil e gestão.
module Admin
  class PerfilController < ApplicationController
    layout "admin"
    before_action :require_login
    before_action :require_admin

    # Exibe os dados do usuário administrador logado.
    # @return [void]
    def show
      @user = current_user
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
