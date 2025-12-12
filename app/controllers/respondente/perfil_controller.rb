# Namespace `Respondente` para exibição de informações de perfil do participante.
class Respondente::PerfilController < ApplicationController
  before_action :require_login
  layout "respondente"

  # Exibe perfil do usuário respondente logado.
  # @return [void]
  def show
    @user = current_user
  end
end
