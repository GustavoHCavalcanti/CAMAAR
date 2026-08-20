# lib/template_manager.rb

# Gerencia templates e permissões de edição/deleção por administrador.
class TemplateManager
  # Mantém uma lista de templates em memória para operações simples.
  # @param templates [Array<Hash>] lista com chaves :id, :nome, :owner_id
  # @return [TemplateManager]
  def initialize(templates)
    # templates é um array de hashes, ex:
    # { id: 1, nome: "Template A", owner_id: 1 }
    @templates = templates
  end

  # Lista templates marcando se o admin pode editar/deletar
  # @param admin_id [Integer]
  # @return [Array<Hash>] cada template com flags :can_edit e :can_delete
  def list_for(admin_id)
    @templates.map do |t|
      t.merge(
        can_edit:   t[:owner_id] == admin_id,
        can_delete: t[:owner_id] == admin_id
      )
    end
  end

  # Simula abertura de editor de template
  # Retorna :editor_opened se o admin for dono do template
  # Retorna :forbidden caso contrário
  # @param template_name [String]
  # @param admin_id [Integer]
  # @return [Symbol] :editor_opened ou :forbidden
  def open_editor(template_name, admin_id)
    template = @templates.find { |t| t[:nome] == template_name }

    return :forbidden unless template
    return :editor_opened if template[:owner_id] == admin_id

    :forbidden
  end

  # Estado vazio do administrador:
  # - Se ele não tiver templates, retorna um hash com mensagem e sugestão
  # - Se tiver pelo menos um template, retorna nil
  # @param admin_id [Integer]
  # @return [Hash, nil] estado vazio ou nil quando existe pelo menos um template
  def empty_state_for(admin_id)
    meus_templates = @templates.select { |t| t[:owner_id] == admin_id }

    if meus_templates.empty?
      {
        message: "Nenhum template criado por você",
        suggest_new_template: true
      }
    else
      nil
    end
  end
end
