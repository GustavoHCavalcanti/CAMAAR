# lib/edicao_delecao_templates.rb

# Regras de edição e deleção de templates, respeitando dependências com formulários.
class TemplateManagerEd
  # Estruturas esperadas:
  #
  # templates = [
  #   { id: 1, nome: "Template A", owner_id: 10 },
  #   { id: 2, nome: "Template Novo", owner_id: 10 }
  # ]
  #
  # forms = [
  #   { id: 1, nome: "Formulário X", template_id: 1 }
  # ]
  #
  # @param templates [Array<Hash>] templates existentes
  # @param forms [Array<Hash>] formulários associados
  # @return [TemplateManagerEd]
  def initialize(templates, forms)
    @templates = templates || []
    @forms = forms || []
  end

  # ============================================================
  # EDIÇÃO DE TEMPLATE
  # ============================================================

  # Edita o nome de um template, mas NÃO altera formulários existentes
  #
  # Retorna:
  #   :edited             → edição bem sucedida
  #   :not_found          → template não existe
  # @param template_nome_atual [String]
  # @param novo_nome [String]
  # @return [Symbol] :edited ou :not_found
  def editar_template(template_nome_atual, novo_nome)
    template = @templates.find { |t| t[:nome] == template_nome_atual }
    return :not_found unless template

    template[:nome] = novo_nome
    :edited
  end

  # ============================================================
  # DELEÇÃO DE TEMPLATE
  # ============================================================

  # Deleta template, mas exige confirmação caso haja formulários associados.
  #
  # Retorna:
  #   :deleted                   → deletado com sucesso
  #   :confirm_required          → há formulários dependentes, confirmação necessária
  #   :not_found                 → template não existe
  #
  # @param template_nome [String]
  # @param confirm [Boolean] confirma deleção mesmo com dependências
  # @return [Symbol] :deleted, :confirm_required ou :not_found
  def deletar_template(template_nome, confirm: false)
    template = @templates.find { |t| t[:nome] == template_nome }
    return :not_found unless template

    relacionado = @forms.any? { |f| f[:template_id] == template[:id] }

    # Caso exista relacionamento e não houve confirmação ainda:
    unless confirm
      return :confirm_required if relacionado
    end

    # Deleta template SEM afetar formulários já existentes
    @templates.delete(template)

    :deleted
  end
end
