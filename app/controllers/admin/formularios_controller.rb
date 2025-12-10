module Admin
  class FormulariosController < ApplicationController
    def index
    end

    def show
    end

    def new
    end

    def create
      flash[:notice] = "Formulário criado (placeholder)"
      redirect_to admin_formularios_path
    end

    def edit
    end

    def update
      flash[:notice] = "Formulário atualizado (placeholder)"
      redirect_to admin_formularios_path
    end

    def destroy
      flash[:alert] = "Formulário apagado (placeholder)"
      redirect_to admin_formularios_path
    end
  end
end