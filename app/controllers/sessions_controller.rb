class SessionsController < ApplicationController
  # Renderiza o formulário de login.
  # @return [void]
  def new
  end

  # Autentica o usuário usando email ou matrícula e inicia a sessão.
  # @param [ActionController::Parameters] params credenciais :login (email ou matrícula) e :password
  # @return [void]
  # @side_effect Define session[:user_id] e redireciona conforme o role; renderiza :new com 422 em falha
  def create
    login_param = params[:login]
    user = localizar_usuario(login_param)
    return falha_login unless user&.authenticate(params[:password])

    session[:user_id] = user.id
    redirect_to caminho_pos_login(user), notice: "Login realizado com sucesso!"
  end

  # Encerra a sessão do usuário autenticado.
  # @return [void]
  # @side_effect Remove session[:user_id] e redireciona para a tela de login
  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Você saiu da sessão."
  end

  private

  def localizar_usuario(identificador)
    User.find_by("email = ? OR matricula = ?", identificador, identificador)
  end

  def falha_login
    flash.now[:alert] = "Email, matrícula ou senha inválidos."
    render :new, status: :unprocessable_entity
  end

  def caminho_pos_login(user)
    user.role_administrador? ? admin_formularios_path : respondente_formularios_path
  end
end
