# lib/gerar_relatorio_administrador.rb
require "csv"

class NoDataToExportError < StandardError; end

# Gera relatórios CSV para visão administrativa, opcionalmente filtrando por turma.
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

  # Seleciona respostas de uma turma específica.
  # @param turma [String]
  # @return [Array<Hash>] respostas filtradas
  def filtrar_por_turma(turma)
    @responses.select { |r| r[:turma] == turma }
  end

  # Constrói CSV a partir da lista de respostas.
  # @param responses [Array<Hash>]
  # @return [String] CSV com cabeçalho
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
