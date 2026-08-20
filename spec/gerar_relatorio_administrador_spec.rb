# spec/gerar_relatorio_administrador_spec.rb
require "spec_helper"
require_relative "../lib/admin_report_generator"

RSpec.describe AdminReportGenerator do
  let(:responses) do
    [
      { turma: "CIC101", aluno: "João",  nota: 8 },
      { turma: "MAT001", aluno: "Maria", nota: 9 },
      { turma: "CIC101", aluno: "Ana",   nota: 7 }
    ]
  end

  context "Exportação de resultados concluída (feliz)" do
    it "gera um CSV contendo todas as respostas registradas" do
      generator = described_class.new(responses)

      csv = generator.export_csv
      linhas = csv.split("\n")

      # header + 3 linhas de dados
      expect(linhas.size).to eq(1 + responses.size)

      expect(linhas.first).to include("turma", "aluno", "nota")
      expect(csv).to include("João")
      expect(csv).to include("Maria")
      expect(csv).to include("Ana")
    end
  end

  context "Exportação filtrada por turma (feliz)" do
    it "gera um CSV contendo apenas os dados da turma específica" do
      generator = described_class.new(responses)

      csv = generator.export_csv(turma: "CIC101")

      expect(csv).to include("João")
      expect(csv).to include("Ana")
      expect(csv).not_to include("Maria")

      linhas = csv.split("\n")
      # header + 2 linhas (apenas CIC101)
      expect(linhas.size).to eq(1 + 2)
    end
  end

  context "Tentativa de exportação sem dados disponíveis (triste)" do
    it "impede a exportação quando o formulário não possui respostas" do
      generator = described_class.new([])

      expect { generator.export_csv }.to raise_error(NoDataToExportError)
    end

    it "impede a exportação quando o filtro de turma não encontra respostas" do
      generator = described_class.new(responses)

      expect { generator.export_csv(turma: "ENG999") }
        .to raise_error(NoDataToExportError)
    end
  end
end
