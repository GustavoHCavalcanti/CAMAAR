# lib/gerenciamento_turmas_departamento.rb

class TurmaManager
  # Estrutura esperada:
  # turmas = [
  #   { codigo: "CIC101 - Turma A", departamento: "Computação", desempenho: {...} },
  #   { codigo: "MAT001 - Turma B", departamento: "Matemática", desempenho: {...} }
  # ]
  #
  # admin = { id: 1, nome: "Admin", departamento: "Computação" }

  # Inicializa com coleção de turmas e o administrador corrente.
  # @param turmas [Array<Hash>]
  # @param admin [Hash]
  # @return [TurmaManager]
  def initialize(turmas, admin)
    @turmas = turmas || []
    @admin  = admin
  end

  # Lista apenas as turmas do departamento do administrador
  def list_for_admin
    @turmas.select { |t| t[:departamento] == @admin[:departamento] }
  end

  # Acessar detalhes de uma turma
  #
  # Retorna:
  #   { status: :success, turma: {...}, pode_editar: true }     -> acesso permitido
  #   { status: :forbidden, message: "...", redirect: :lista } -> acesso negado
  #   { status: :not_found }                                   -> turma inexistente
  def acesso_turma(codigo_turma)
    turma = @turmas.find { |t| t[:codigo] == codigo_turma }
    return { status: :not_found } unless turma

    if turma[:departamento] == @admin[:departamento]
      return {
        status: :success,
        turma: turma,
        pode_editar: true
      }
    else
      return {
        status: :forbidden,
        message: "A turma pertence a outro departamento",
        redirect: :lista
      }
    end
  end
end
