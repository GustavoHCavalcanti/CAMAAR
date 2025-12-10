module Admin
  class TemplatesController < ApplicationController
    def index
    end

    def show
    end

    def new
    end

    def create
      flash[:notice] = "Template criado (placeholder)"
      redirect_to admin_templates_path
    end

    def edit
    end

    def update
      flash[:notice] = "Template atualizado (placeholder)"
      redirect_to admin_templates_path
    end

    def destroy
      flash[:alert] = "Template deletado (placeholder)"
      redirect_to admin_templates_path
    end
  end
end