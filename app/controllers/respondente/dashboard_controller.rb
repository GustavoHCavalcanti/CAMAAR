module Respondente
  class DashboardController < ApplicationController
    before_action :require_login
    before_action :require_respondente

    def index
    end

    private

    def require_respondente
      redirect_to root_path, alert: "Acesso negado." unless current_user&.role_participante?
    end
  end
end
