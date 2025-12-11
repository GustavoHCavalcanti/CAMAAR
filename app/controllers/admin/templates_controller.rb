module Admin
  class TemplatesController < ApplicationController
    layout "admin"
    before_action :require_login
    before_action :require_admin

    def index
      @templates = ::Template.all
    end

    def show
      @template = ::Template.find(params[:id])
    end

    def new
      @template = ::Template.new
      @template.questions.build # Inicializa com uma pergunta vazia
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
      params.require(:template).permit(
        :nome,
        questions_attributes: [ :id, :texto, :tipo, :_destroy, options: [] ]
      )
    end

    def require_admin
      redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
    end
  end
end
