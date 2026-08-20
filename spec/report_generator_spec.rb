# spec/report_generator_spec.rb
require 'report_generator'

RSpec.describe ReportGenerator do
  let(:responses) do
    [
      { turma: 'A', aluno: 'João',  nota: 8 },
      { turma: 'B', aluno: 'Maria', nota: 9 },
      { turma: 'A', aluno: 'Ana',   nota: 7 }
    ]
  end

  context 'Exportação de resultados concluída (feliz)' do
    it 'gera um CSV contendo todas as respostas registradas' do
      generator = ReportGenerator.new(responses)

      csv = generator.export_csv

      lines = csv.split("\n")
      # header + 3 linhas de resposta
      expect(lines.size).to eq(1 + responses.size)

      expect(lines.first).to include('turma', 'aluno', 'nota')
      expect(csv).to include('João')
      expect(csv).to include('Maria')
      expect(csv).to include('Ana')
    end
  end

  context 'Exportação filtrada por turma (feliz)' do
    it 'gera um CSV contendo apenas os dados da turma informada' do
      generator = ReportGenerator.new(responses)

      csv = generator.export_csv(classroom: 'A')

      expect(csv).to include('João')
      expect(csv).to include('Ana')
      expect(csv).not_to include('Maria')

      lines = csv.split("\n")
      # header + 2 linhas (apenas turma A)
      expect(lines.size).to eq(1 + 2)
    end
  end

  context 'Tentativa de exportação sem dados disponíveis (triste)' do
    it 'impede a exportação quando não há nenhuma resposta' do
      generator = ReportGenerator.new([])

      expect { generator.export_csv }.to raise_error(NoDataToExportError)
    end

    it 'impede a exportação quando o filtro remove todos os dados' do
      generator = ReportGenerator.new(responses)

      expect { generator.export_csv(classroom: 'X') }
        .to raise_error(NoDataToExportError)
    end
  end
end
