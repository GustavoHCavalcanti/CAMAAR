module Admin
  class TurmasController < ApplicationController
    layout "admin"
    before_action :require_login
    before_action :require_admin

    def index
      @turmas = ::Turma.all
    end

    def show
      @turma = ::Turma.find(params[:id])
    end

    def new
      @turma = ::Turma.new
      @alunos_disponiveis = ::User.where(role: "participante")
      @professores = ::User.where(role: "administrador")
    end

    def create
      @turma = ::Turma.new(turma_params)
      if @turma.save
        # Associar alunos selecionados
        if params[:turma][:aluno_ids].present?
          params[:turma][:aluno_ids].each do |aluno_id|
            @turma.turma_users.create(user_id: aluno_id) unless aluno_id.blank?
          end
        end
        redirect_to admin_turmas_path, notice: "Turma criada com sucesso!"
      else
        @alunos_disponiveis = ::User.where(role: "participante")
        @professores = ::User.where(role: "administrador")
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @turma = ::Turma.find(params[:id])
      @alunos_disponiveis = ::User.where(role: "participante")
      @alunos_da_turma = @turma.users
      @professores = ::User.where(role: "administrador")
    end

    def update
      @turma = ::Turma.find(params[:id])
      if @turma.update(turma_params)
        # Atualizar alunos da turma
        # Primeiro, remover todas as associações
        @turma.turma_users.destroy_all
        # Depois, adicionar os selecionados
        if params[:turma][:aluno_ids].present?
          params[:turma][:aluno_ids].each do |aluno_id|
            @turma.turma_users.create(user_id: aluno_id) unless aluno_id.blank?
          end
        end
        redirect_to admin_turmas_path, notice: "Turma atualizada!"
      else
        @alunos_disponiveis = ::User.where(role: "participante")
        @alunos_da_turma = @turma.users
        @professores = ::User.where(role: "administrador")
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @turma = ::Turma.find(params[:id])
      @turma.destroy
      redirect_to admin_turmas_path, notice: "Turma removida."
    end

    private

    def turma_params
      params.require(:turma).permit(:codigo, :departamento, :semestre, :professor)
    end

    def require_admin
      redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
    end
  end
end
