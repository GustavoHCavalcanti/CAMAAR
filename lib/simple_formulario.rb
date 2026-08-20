# lib/simple_formulario.rb

# Representação simplificada de formulário para uso em cenários e testes.
class SimpleFormulario
  attr_reader :id, :turma_id
  attr_accessor :respondido_por

  # Formulário simplificado usado em cenários/mock.
  # @param id [Integer]
  # @param turma_id [Integer]
  # @param respondido_por [Array] lista de identificadores de quem já respondeu
  # @return [SimpleFormulario]
  def initialize(id:, turma_id:, respondido_por: [])
    @id = id
    @turma_id = turma_id
    @respondido_por = respondido_por
  end

  # Retorna true se o formulário ainda está pendente para esse usuário
  # @param usuario [Object] identificador do usuário
  # @return [Boolean] true quando usuário ainda não respondeu
  def pendente_para?(usuario)
    !respondido_por.include?(usuario)
  end
end
