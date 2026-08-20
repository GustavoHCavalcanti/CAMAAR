# Namespace de controllers administrativos, com layout "admin" e filtros de acesso.
module Admin
  class TemplatesController < ApplicationController
    layout "admin"
    before_action :require_login
    before_action :require_admin

    # Lista todos os templates cadastrados.
    # @return [void]
    def index
      @templates = ::Template.all
    end

    # Exibe um template específico.
    # @return [void]
    def show
      @template = ::Template.find(params[:id])
    end

    # Inicializa um novo template com uma pergunta vazia.
    # @return [void]
    def new
      @template = ::Template.new
      @template.questions.build # Inicializa com uma pergunta vazia
    end

    # Cria um template e redireciona em caso de sucesso.
    # @return [void]
    # @side_effect Persiste Template; redireciona ou renderiza :new com status 422
    def create
      @template = ::Template.new(template_params)
      if @template.save
        redirect_to admin_templates_path, notice: "Template criado com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    # Carrega template para edição.
    # @return [void]
    def edit
      @template = ::Template.find(params[:id])
    end

    # Atualiza um template existente.
    # @return [void]
    # @side_effect Persiste alterações; redireciona ou renderiza :edit com status 422
    def update
      @template = ::Template.find(params[:id])
      if @template.update(template_params)
        redirect_to admin_templates_path, notice: "Template atualizado!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # Remove um template definitivamente.
    # @return [void]
    # @side_effect Destroi registro e redireciona
    def destroy
      @template = ::Template.find(params[:id])
      @template.destroy
      redirect_to admin_templates_path, notice: "Template removido."
    end

    private

    # Strong params para template e perguntas associadas.
    # @return [ActionController::Parameters]
    def template_params
      params.require(:template).permit(
        :nome,
        questions_attributes: [ :id, :texto, :tipo, :_destroy, options: [] ]
      )
    end

    # Restringe acesso a administradores.
    # @return [void]
    # @side_effect Redireciona com alerta quando não admin
    def require_admin
      redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
    end
  end
end
