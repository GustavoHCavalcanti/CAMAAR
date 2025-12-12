class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_admin

  # Restringe acesso a usuários administradores; redireciona visitantes ou participantes.
  # @return [void]
  # @side_effect Redireciona para root_path se o usuário não for administrador
  def require_admin
    redirect_to root_path unless current_user&.administrador?
  end
end