module Admin
  class TemplatesController < ApplicationController
    def index
      @templates = ::Template.all
    end

    def show
      @template = ::Template.find(params[:id])
    end

    def new
      @template = ::Template.new
    end

    def create
      @template = ::Template.new(template_params)
      if @template.save
        redirect_to admin_templates_path, notice: "Template criado com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @template = ::Template.find(params[:id])
    end

    def update
      @template = ::Template.find(params[:id])
      if @template.update(template_params)
        redirect_to admin_templates_path, notice: "Template atualizado!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @template = ::Template.find(params[:id])
      @template.destroy
      redirect_to admin_templates_path, notice: "Template removido."
    end

    private

    def template_params
      params.require(:template).permit(:nome, :descricao)
    end
  end
end
