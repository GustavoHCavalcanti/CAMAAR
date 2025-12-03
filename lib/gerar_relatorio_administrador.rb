# lib/gerar_relatorio_administrador.rb
require "csv"

class NoDataToExportError < StandardError; end

class AdminReportGenerator
  # responses: array de hashes, por exemplo:
  # [
  #   { turma: "CIC101", aluno: "João", nota: 8 },
  #   { turma: "CIC101", aluno: "Maria", nota: 9 },
  #   { turma: "MAT001", aluno: "Ana", nota: 7 }
  # ]
  def initialize(responses)
    @responses = responses || []
  end

  # Parâmetro opcional turma: exporta tudo ou só de uma turma específica
  #
  # Retorno:
  # - String CSV (com header) quando há dados
  # - lança NoDataToExportError quando não há dados
  def export_csv(turma: nil)
    selecionadas = turma ? filtrar_por_turma(turma) : @responses

    raise NoDataToExportError, "Nenhum dado disponível para exportação" if selecionadas.empty?

    gerar_csv(selecionadas)
  end

  private

  def filtrar_por_turma(turma)
    @responses.select { |r| r[:turma] == turma }
  end

  def gerar_csv(responses)
    CSV.generate(headers: true) do |csv|
      headers = responses.first.keys
      csv << headers
      responses.each do |resp|
        csv << headers.map { |chave| resp[chave] }
      end
    end
  end
end
