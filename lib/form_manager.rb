# lib/form_manager.rb

class FormManager
  # user                → objeto User
  # turmas_ids_usuario  → array de IDs/códigos de turmas nas quais o usuário está
  # formularios         → array de objetos Formulario
  def formularios_pendentes(user, turmas_ids_usuario, formularios)
    formularios.select do |form|
      turmas_ids_usuario.include?(form.turma_id) &&
        !form.respondido_por.include?(user)
    end
  end
end
