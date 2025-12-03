# lib/sigaa_importer.rb

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
  def import(data)
    import_type(:turmas,        data[:turmas]        || [])
    import_type(:materias,      data[:materias]      || [])
    import_type(:participantes, data[:participantes] || [])
  end

  private

  def import_type(type, records)
    base = @database[type]

    records.each do |record|
      # aqui a igualdade é pelo hash inteiro; se já existe um igual, não adiciona
      base << record unless base.include?(record)
    end
  end
end
