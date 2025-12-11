# lib/simple_formulario.rb

class SimpleFormulario
  attr_reader :id, :turma_id
  attr_accessor :respondido_por

  def initialize(id:, turma_id:, respondido_por: [])
    @id = id
    @turma_id = turma_id
    @respondido_por = respondido_por
  end

  # Retorna true se o formulário ainda está pendente para esse usuário
  def pendente_para?(usuario)
    !respondido_por.include?(usuario)
  end
end
