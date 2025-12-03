# spec/sigaa_importer_spec.rb
require_relative '../lib/sigaa_importer'

RSpec.describe SigaaImporter do
  let(:database) do
    {
      turmas: [
        { codigo: 'T1', nome: 'Turma 1' }
      ],
      materias: [
        { codigo: 'M1', nome: 'Matemática I' }
      ],
      participantes: [
        { matricula: '111', nome: 'João' }
      ]
    }
  end

  context 'Importação com dados novos (feliz)' do
    it 'inclui apenas registros que não existem na base' do
      importer = SigaaImporter.new(database)

      dados_sigaa = {
        turmas: [
          { codigo: 'T1', nome: 'Turma 1' }, # já existe
          { codigo: 'T2', nome: 'Turma 2' }  # nova
        ],
        materias: [
          { codigo: 'M1', nome: 'Matemática I' }, # já existe
          { codigo: 'M2', nome: 'Física I' }      # nova
        ],
        participantes: [
          { matricula: '111', nome: 'João' },     # já existe
          { matricula: '222', nome: 'Maria' }     # nova
        ]
      }

      importer.import(dados_sigaa)

      # turmas
      expect(database[:turmas]).to include({ codigo: 'T1', nome: 'Turma 1' })
      expect(database[:turmas]).to include({ codigo: 'T2', nome: 'Turma 2' })
      expect(database[:turmas].size).to eq(2)

      # materias
      expect(database[:materias]).to include({ codigo: 'M1', nome: 'Matemática I' })
      expect(database[:materias]).to include({ codigo: 'M2', nome: 'Física I' })
      expect(database[:materias].size).to eq(2)

      # participantes
      expect(database[:participantes]).to include({ matricula: '111', nome: 'João' })
      expect(database[:participantes]).to include({ matricula: '222', nome: 'Maria' })
      expect(database[:participantes].size).to eq(2)
    end
  end

  context 'Dados já existentes (triste)' do
    it 'não cria novos registros quando todos já existem' do
      importer = SigaaImporter.new(database)

      dados_sigaa = {
        turmas: [
          { codigo: 'T1', nome: 'Turma 1' }
        ],
        materias: [
          { codigo: 'M1', nome: 'Matemática I' }
        ],
        participantes: [
          { matricula: '111', nome: 'João' }
        ]
      }

      expect {
        importer.import(dados_sigaa)
      }.not_to change {
        [
          database[:turmas].size,
          database[:materias].size,
          database[:participantes].size
        ]
      }

      expect(database[:turmas]).to eq([{ codigo: 'T1', nome: 'Turma 1' }])
      expect(database[:materias]).to eq([{ codigo: 'M1', nome: 'Matemática I' }])
      expect(database[:participantes]).to eq([{ matricula: '111', nome: 'João' }])
    end
  end
end
