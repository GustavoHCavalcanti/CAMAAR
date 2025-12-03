# lib/report_generator.rb
require 'csv'

class NoDataToExportError < StandardError; end

class ReportGenerator
  # responses: array de hashes, ex:
  # [{ turma: "A", aluno: "João", nota: 8 }, ...]
  def initialize(responses)
    @responses = responses || []
  end

  # classroom é opcional (turma)
  def export_csv(classroom: nil)
    filtered = classroom ? filter_by_classroom(classroom) : @responses

    raise NoDataToExportError, "Nenhum dado disponível para exportação" if filtered.empty?

    build_csv(filtered)
  end

  private

  def filter_by_classroom(classroom)
    @responses.select { |r| r[:turma] == classroom }
  end

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
