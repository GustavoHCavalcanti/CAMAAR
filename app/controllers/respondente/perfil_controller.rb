# Namespace `Respondente` para exibição de informações de perfil do participante.
class Respondente::PerfilController < ApplicationController
  before_action :require_login
  layout "respondente"

  # Exibe perfil do usuário respondente logado.
  # @return [void]
  def show
    @user = current_user
  end

  # Exibe formulário para alterar senha.
  # @return [void]
  def edit_password
    @user = current_user
  end

  # Atualiza a senha do usuário.
  # @return [void]
  # @side_effect Atualiza senha do usuário; redireciona com mensagem de sucesso ou erro
  def update_password
    @user = current_user

    unless @user.authenticate(params[:current_password])
      flash.now[:alert] = "Senha atual incorreta."
      render :edit_password, status: :unprocessable_entity
      return
    end

    if params[:new_password] != params[:password_confirmation]
      flash.now[:alert] = "A nova senha e a confirmação não coincidem."
      render :edit_password, status: :unprocessable_entity
      return
    end

    if @user.update(password: params[:new_password], password_confirmation: params[:password_confirmation])
      redirect_to respondente_perfil_path, notice: "Senha alterada com sucesso!"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit_password, status: :unprocessable_entity
    end
  end
end
