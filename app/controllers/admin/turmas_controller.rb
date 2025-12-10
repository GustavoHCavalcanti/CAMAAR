module Admin
  class TurmasController < ApplicationController
    def index
    end

    def show
    end

    def new
    end

    def create
      flash[:notice] = "Turma criada (placeholder)"
      redirect_to admin_turmas_path
    end

    def edit
    end

    def update
      flash[:notice] = "Turma atualizada (placeholder)"
      redirect_to admin_turmas_path
    end

    def destroy
      flash[:alert] = "Turma deletada (placeholder)"
      redirect_to admin_turmas_path
    end
  end
end