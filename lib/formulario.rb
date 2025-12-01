# lib/formulario.rb

class Formulario
  attr_reader :id, :turma_id
  attr_accessor :respondido_por

  def initialize(id:, turma_id:, respondido_por: [])
    @id = id
    @turma_id = turma_id
    @respondido_por = respondido_por
  end

  def pendente_para?(usuario)
    !respondido_por.include?(usuario)
  end
end
