# lib/report_generator.rb
require 'csv'

class NoDataToExportError < StandardError; end

# Gera relatórios CSV a partir de respostas coletadas, com filtros por turma.
class ReportGenerator
  # responses: array de hashes, ex:
  # [{ turma: "A", aluno: "João", nota: 8 }, ...]
  def initialize(responses)
    @responses = responses || []
  end

  # classroom é opcional (turma)
  # @param classroom [String, nil] código da turma para filtrar
  # @return [String] CSV gerado
  # @raise [NoDataToExportError] quando não há dados para exportar
  def export_csv(classroom: nil)
    filtered = classroom ? filter_by_classroom(classroom) : @responses

    raise NoDataToExportError, "Nenhum dado disponível para exportação" if filtered.empty?

    build_csv(filtered)
  end

  private

  # Filtra respostas por turma.
  # @param classroom [String]
  # @return [Array<Hash>] respostas filtradas
  def filter_by_classroom(classroom)
    @responses.select { |r| r[:turma] == classroom }
  end

  # Monta o CSV com cabeçalho.
  # @param responses [Array<Hash>]
  # @return [String] CSV
  def build_csv(responses)
    CSV.generate(headers: true) do |csv|
      headers = responses.first.keys
      csv << headers
      responses.each do |response|
        csv << headers.map { |key| response[key] }
      end
    end
  end
end
