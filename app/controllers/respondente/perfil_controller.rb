class Respondente::PerfilController < ApplicationController
  before_action :require_login
  layout "respondente"

  def show
    @user = current_user
  end
end
