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
    # Aceita email OU matrícula como identificador
    login_param = params[:login]
    user = User.find_by("email = ? OR matricula = ?", login_param, login_param)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      # Redirecionar baseado no role do usuário
      redirect_path = user.role_administrador? ? admin_formularios_path : respondente_formularios_path
      redirect_to redirect_path, notice: "Login realizado com sucesso!"
    else
      flash.now[:alert] = "Email, matrícula ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  # Encerra a sessão do usuário autenticado.
  # @return [void]
  # @side_effect Remove session[:user_id] e redireciona para a tela de login
  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Você saiu da sessão."
  end
end
