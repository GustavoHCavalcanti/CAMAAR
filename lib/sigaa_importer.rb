# lib/sigaa_importer.rb

# Importa dados do SIGAA para a base local, evitando duplicidades.
class SigaaImporter
  # "database" é um hash com arrays:
  # {
  #   turmas:        [ { ... }, ... ],
  #   materias:      [ { ... }, ... ],
  #   participantes: [ { ... }, ... ]
  # }
  def initialize(database)
    @database = database
    @database[:turmas]        ||= []
    @database[:materias]      ||= []
    @database[:participantes] ||= []
  end

  # "data" tem o mesmo formato do database, com os dados vindos do SIGAA
  # @param data [Hash] coleções de turmas, materias e participantes
  # @return [void]
  def import(data)
    import_type(:turmas,        data[:turmas]        || [])
    import_type(:materias,      data[:materias]      || [])
    import_type(:participantes, data[:participantes] || [])
  end

  private

  # Importa registros de um tipo, evitando duplicatas no banco local.
  # @param type [Symbol] chave de coleção (:turmas, :materias, :participantes)
  # @param records [Array<Hash>] registros a importar
  # @return [void]
  # @side_effect Acrescenta novos registros em @database[type]
  def import_type(type, records)
    base = @database[type]

    records.each do |record|
      # aqui a igualdade é pelo hash inteiro; se já existe um igual, não adiciona
      base << record unless base.include?(record)
    end
  end
end
