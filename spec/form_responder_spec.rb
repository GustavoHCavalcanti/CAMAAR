# spec/form_responder_spec.rb

require "spec_helper"
require_relative "../lib/user"
require_relative "../lib/formulario"      
require_relative "../lib/form_responder"

RSpec.describe FormResponder do
  let(:usuario) do
    User.new(
      email: "aluno@unb.br",
      matricula: "CIC101",
      senha: "Senha123",
      role: :participante
    )
  end

  let(:formulario) do
    Formulario.new(
      id: 1,
      turma_id: "CIC101",
      respondido_por: []
    )
  end

  let(:perguntas_obrigatorias) { [:q1, :q2] }

  subject(:responder) { described_class.new }

  describe "#responder" do
    context "quando o participante preenche as respostas obrigatórias" do
      it "registra a avaliação" do
        respostas = {
          q1: "Muito bom",
          q2: "Comentário sobre a disciplina"
        }

        resultado = responder.responder(
          formulario: formulario,
          usuario: usuario,
          respostas: respostas,
          perguntas_obrigatorias: perguntas_obrigatorias
        )

        expect(resultado).to eq :sucesso
        expect(formulario.respondido_por).to include(usuario)
      end
    end

    context "quando o participante deixa perguntas obrigatórias sem resposta" do
      it "rejeita o envio da avaliação" do
        respostas = {
          q1: "Muito bom" # faltou q2
        }

        resultado = responder.responder(
          formulario: formulario,
          usuario: usuario,
          respostas: respostas,
          perguntas_obrigatorias: perguntas_obrigatorias
        )

        expect(resultado).to eq :campos_obrigatorios_em_branco
        expect(formulario.respondido_por).not_to include(usuario)
      end
    end
  end
end
