class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  # Resolve o usuário autenticado a partir da sessão e memoriza para evitar consultas repetidas.
  # @return [User, nil] usuário autenticado ou nil quando não há sessão ativa
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Verifica se há usuário autenticado disponível.
  # @return [Boolean] true quando existe usuário atual, false caso contrário
  def logged_in?
    current_user.present?
  end

  # Garante que apenas usuários autenticados acessem a rota.
  # @side_effect Redireciona para login_path quando não autenticado
  def require_login
    redirect_to login_path unless logged_in?
  end

  # Define o layout padrão para telas de respondente.
  # @return [String] nome do layout utilizado para respondentes
  def respondente_layout
    "respondente"
  end
end
