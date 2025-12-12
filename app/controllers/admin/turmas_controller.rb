# Namespace de controllers administrativos para gestão de turmas.
module Admin
  class TurmasController < ApplicationController
    layout "admin"
    before_action :require_login
    before_action :require_admin

    # Lista turmas cadastradas.
    # @return [void]
    def index
      @turmas = ::Turma.all
    end

    # Exibe detalhes de uma turma.
    # @return [void]
    def show
      @turma = ::Turma.find(params[:id])
    end

    # Inicializa formulário de criação de turma com listas de alunos e professores.
    # @return [void]
    def new
      @turma = ::Turma.new
      @alunos_disponiveis = ::User.where(role: "participante")
      @professores = ::User.where(role: "administrador")
    end

    # Cria turma e associa alunos selecionados.
    # @return [void]
    # @side_effect Persiste Turma e TurmaUsers; redireciona ou renderiza :new com status 422
    def create
      @turma = ::Turma.new(turma_params)
      if @turma.save
        # Associar alunos selecionados
        associar_alunos(@turma, params[:turma][:aluno_ids]) if params[:turma][:aluno_ids].present?
        redirect_to admin_turmas_path, notice: "Turma criada com sucesso!"
      else
        @alunos_disponiveis = ::User.where(role: "participante")
        @professores = ::User.where(role: "administrador")
        render :new, status: :unprocessable_entity
      end
    end

    # Carrega turma para edição e popula alunos atuais e disponíveis.
    # @return [void]
    def edit
      @turma = ::Turma.find(params[:id])
      @alunos_disponiveis = ::User.where(role: "participante")
      @alunos_da_turma = @turma.users
      @professores = ::User.where(role: "administrador")
    end

    # Atualiza turma e redefine associações de alunos conforme seleção.
    # @return [void]
    # @side_effect Limpa e recria TurmaUsers; redireciona ou renderiza :edit com status 422
    def update
      @turma = ::Turma.find(params[:id])
      if @turma.update(turma_params)
        # Atualizar alunos da turma
        redefinir_associacoes_alunos(@turma, params[:turma][:aluno_ids])
        redirect_to admin_turmas_path, notice: "Turma atualizada!"
      else
        @alunos_disponiveis = ::User.where(role: "participante")
        @alunos_da_turma = @turma.users
        @professores = ::User.where(role: "administrador")
        render :edit, status: :unprocessable_entity
      end
    end

    # Remove turma definitivamente.
    # @return [void]
    # @side_effect Destroi Turma e associações; redireciona
    def destroy
      @turma = ::Turma.find(params[:id])
      @turma.destroy
      redirect_to admin_turmas_path, notice: "Turma removida."
    end

    # Exibe formulário de importação CSV de turmas/alunos.
    # @return [void]
    def import_form
      # Apenas renderiza o formulário de upload
    end

    # Processa importação de turmas/alunos via CSV.
    # @return [void]
    # @side_effect Cria/atualiza Turma e Users via serviço; redireciona com mensagem de resultado
    def import
      return redirect_to(import_form_admin_turmas_path, alert: "Envie um arquivo CSV para importar.") if params[:file].blank?

      result = ::TurmaImportService.new(file: params[:file]).call
      handle_import_result(result)
    end

    private

    # Strong params da turma.
    # @return [ActionController::Parameters]
    def turma_params
      params.require(:turma).permit(:codigo, :departamento, :semestre, :professor)
    end

    # Restringe acesso a administradores.
    # @return [void]
    # @side_effect Redireciona com alerta quando não admin
    def require_admin
      redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
    end

    def associar_alunos(turma, aluno_ids)
      return if aluno_ids.blank?
      aluno_ids.each do |aluno_id|
        next if aluno_id.blank?
        turma.turma_users.create(user_id: aluno_id)
      end
    end

    def preparar_listas_turma(turma = nil)
      @alunos_disponiveis = ::User.where(role: "participante")
      @professores = ::User.where(role: "administrador")
      @alunos_da_turma = turma&.users if turma
    end

    def redefinir_associacoes_alunos(turma, aluno_ids)
      turma.turma_users.destroy_all
      associar_alunos(turma, aluno_ids)
    end

    def handle_import_result(result)
      if result.success?
        redirect_to admin_turmas_path, notice: build_import_message(result)
      else
        redirect_to import_form_admin_turmas_path, alert: result.message
      end
    end

    def build_import_message(result)
      base = "Importação concluída. Turmas novas: #{result.created_turmas}. Alunos novos: #{result.created_users}. Alunos já existentes: #{result.existing_users}."
      return base unless result.errors.present?
      observacoes = result.errors.first(3).join(' | ')
      "#{base} Observações: #{observacoes}"
    end
  end
end
