# spec/edicao_delecao_templates_spec.rb
require_relative '../lib/edicao_delecao_templates'

RSpec.describe TemplateManagerED do
  let(:templates) do
    [
      { id: 1, nome: "Template A", owner_id: 10 },
      { id: 2, nome: "Template Novo", owner_id: 10 }
    ]
  end

  let(:forms) do
    [
      { id: 1, nome: "Formulário X", template_id: 1 }
    ]
  end

  describe "Edição bem-sucedida de um template" do
    it 'atualiza o nome do template e mantém o formulário original intacto' do
      manager = TemplateManagerED.new(templates, forms)

      resultado = manager.editar_template("Template A", "Template B - Revisado")

      expect(resultado).to eq(:edited)

      template = templates.find { |t| t[:id] == 1 }
      expect(template[:nome]).to eq("Template B - Revisado")

      formulario = forms.find { |f| f[:id] == 1 }
      expect(formulario[:nome]).to eq("Formulário X") # permanece inalterado
      expect(formulario[:template_id]).to eq(1)       # baseado no template original
    end
  end

  describe "Deleção de template não utilizado" do
    it 'remove o template quando ele nunca foi usado' do
      manager = TemplateManagerED.new(templates, forms)

      resultado = manager.deletar_template("Template Novo")

      expect(resultado).to eq(:deleted)
      expect(templates.any? { |t| t[:nome] == "Template Novo" }).to be false
    end
  end

  describe "Deleção de template utilizado" do
    it 'solicita confirmação quando há formulários relacionados' do
      manager = TemplateManagerED.new(templates, forms)

      resultado = manager.deletar_template("Template A")

      expect(resultado).to eq(:confirm_required)
    end

    it 'remove o template após confirmação explícita, mantendo formulários' do
      manager = TemplateManagerED.new(templates, forms)

      resultado = manager.deletar_template("Template A", confirm: true)

      expect(resultado).to eq(:deleted)
      expect(templates.any? { |t| t[:nome] == "Template A" }).to be false

      # Formulário continua existindo normalmente
      formulario = forms.find { |f| f[:id] == 1 }
      expect(formulario).not_to be_nil
      expect(formulario[:nome]).to eq("Formulário X")
    end
  end
end
