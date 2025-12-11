class SessionsController < ApplicationController
  def new
  end

  def create
    # Aceita email OU matrícula como identificador
    login_param = params[:login]
    user = User.find_by("email = ? OR matricula = ?", login_param, login_param)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Login realizado com sucesso!"
    else
      flash.now[:alert] = "Email, matrícula ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Você saiu da sessão."
  end
end
