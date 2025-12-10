class SessionsController < ApplicationController
  def new
  end

  def create
    # TODO: lógica de autenticação real
    flash[:notice] = "Login de teste realizado."
    redirect_to root_path
  end

  def destroy
    # TODO: logout real
    flash[:notice] = "Logout realizado."
    redirect_to login_path
  end
end