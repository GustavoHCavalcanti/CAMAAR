# spec/template_manager_spec.rb
require_relative '../lib/template_manager'

RSpec.describe TemplateManager do
  let(:admin_id)      { 1 }
  let(:other_admin_id){ 2 }

  let(:templates) do
    [
      { id: 1, nome: 'Template de Avaliação 2024', owner_id: admin_id },
      { id: 2, nome: 'Template de Pesquisa',        owner_id: other_admin_id }
    ]
  end

  describe 'Listar templates criados pelo próprio administrador' do
    it 'marca o template próprio com opções de editar e deletar e o de outro admin como somente leitura' do
      manager = TemplateManager.new(templates)

      lista = manager.list_for(admin_id)

      avaliacao = lista.find { |t| t[:nome] == 'Template de Avaliação 2024' }
      pesquisa  = lista.find { |t| t[:nome] == 'Template de Pesquisa' }

      expect(avaliacao[:can_edit]).to   be true
      expect(avaliacao[:can_delete]).to be true

      expect(pesquisa[:can_edit]).to   be false
      expect(pesquisa[:can_delete]).to be false
    end
  end

  describe 'Acesso à tela de edição' do
    it 'abre o editor quando o administrador clica em editar em um template próprio' do
      manager = TemplateManager.new(templates)

      resultado = manager.open_editor('Template de Avaliação 2024', admin_id)

      expect(resultado).to eq(:editor_opened)
    end

    it 'impede a edição de template que pertence a outro administrador' do
      manager = TemplateManager.new(templates)

      resultado = manager.open_editor('Template de Pesquisa', admin_id)

      expect(resultado).to eq(:forbidden)
    end
  end

  describe 'Administrador sem templates criados' do
    it 'exibe mensagem de vazio e sugere criação de novo template' do
      # admin 3 não possui nenhum template
      manager = TemplateManager.new(templates)
      mensagem = manager.empty_state_for(3)

      expect(mensagem).not_to be_nil
      expect(mensagem[:message]).to eq('Nenhum template criado por você')
      expect(mensagem[:suggest_new_template]).to be true
    end

    it 'não exibe mensagem de vazio quando o admin possui templates' do
      manager = TemplateManager.new(templates)

      mensagem = manager.empty_state_for(admin_id)

      expect(mensagem).to be_nil
    end
  end
end
