# spec/form_manager_spec.rb

require "spec_helper"
require_relative "../lib/form_manager"
require_relative "../lib/user"
require_relative "../lib/formulario"

RSpec.describe FormManager do
  subject(:manager) { described_class.new }

  let(:user) { User.new(email: "aluno@unb.br", matricula: "123", senha: "abc", role: :respondente) }
  let(:form1) { Formulario.new(id: 1, turma_id: "CIC101", respondido_por: []) }
  let(:form2) { Formulario.new(id: 2, turma_id: "MAT001", respondido_por: []) }

  describe "#formularios_pendentes" do
    context "quando o usuário tem formulários pendentes" do
      it "retorna apenas os não respondidos" do
        resultado = manager.formularios_pendentes(user, ["CIC101"], [form1, form2])
        expect(resultado).to contain_exactly(form1)
      end
    end

    context "quando o usuário respondeu todos os formulários" do
      it "retorna lista vazia" do
        # 🔥 Correção: marca como respondido ANTES de chamar o método
        form1.respondido_por << user
        form2.respondido_por << user

        resultado = manager.formularios_pendentes(user, ["CIC101"], [form1, form2])
        expect(resultado).to be_empty
      end
    end

    context "quando o usuário tenta acessar formulário de outra turma" do
      it "não retorna formulários de turmas não cadastradas" do
        resultado = manager.formularios_pendentes(user, ["CIC101"], [form2])
        expect(resultado).to be_empty
      end
    end
  end
end
