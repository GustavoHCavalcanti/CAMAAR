class Formulario
  attr_accessor :id, :turma_id, :respondido_por

  def initialize(id:, turma_id:, respondido_por: [])
    @id = id
    @turma_id = turma_id
    @respondido_por = respondido_por
  end
end
