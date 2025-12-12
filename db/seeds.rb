# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Iniciando seeds..."

# Criar usuário admin se não existir
admin = User.find_or_create_by!(email: "admin@camaar.com") do |u|
  u.nome = "Administrador"
  u.matricula = "ADMIN001"
  u.password = "123456"
  u.password_confirmation = "123456"
  u.role = "administrador"
end
puts "✓ Admin criado: #{admin.email}"

# Templates bem estruturados
templates_data = [
  {
    nome: "Avaliação de Disciplina",
    descricao: "Template para avaliação do desempenho de disciplinas oferecidas",
    questions: [
      { texto: "Como você avalia a qualidade do conteúdo apresentado?", tipo: "radio", options: ["Excelente", "Bom", "Regular", "Ruim", "Péssimo"], obrigatoria: true },
      { texto: "Os objetivos da disciplina foram claramente apresentados?", tipo: "radio", options: ["Sim", "Parcialmente", "Não"], obrigatoria: true },
      { texto: "O material didático fornecido foi adequado?", tipo: "radio", options: ["Muito adequado", "Adequado", "Pouco adequado", "Inadequado"], obrigatoria: true },
      { texto: "A carga horária foi suficiente para o conteúdo?", tipo: "radio", options: ["Sim", "Parcialmente", "Não"], obrigatoria: false },
      { texto: "Comentários e sugestões sobre a disciplina:", tipo: "text", obrigatoria: false }
    ]
  },
  {
    nome: "Avaliação Docente",
    descricao: "Template para avaliação do desempenho de professores",
    questions: [
      { texto: "O professor demonstrou domínio do conteúdo?", tipo: "radio", options: ["Sempre", "Frequentemente", "Às vezes", "Raramente", "Nunca"], obrigatoria: true },
      { texto: "As aulas foram bem organizadas e preparadas?", tipo: "radio", options: ["Concordo totalmente", "Concordo", "Neutro", "Discordo", "Discordo totalmente"], obrigatoria: true },
      { texto: "O professor foi claro nas explicações?", tipo: "radio", options: ["Sempre", "Frequentemente", "Às vezes", "Raramente", "Nunca"], obrigatoria: true },
      { texto: "Houve disponibilidade para atendimento extraclasse?", tipo: "radio", options: ["Sempre disponível", "Geralmente disponível", "Pouco disponível", "Nunca disponível"], obrigatoria: false },
      { texto: "O professor utilizou recursos didáticos variados?", tipo: "radio", options: ["Sim", "Parcialmente", "Não"], obrigatoria: false },
      { texto: "Sugestões para melhoria do ensino:", tipo: "text", obrigatoria: false }
    ]
  },
  {
    nome: "Infraestrutura e Recursos",
    descricao: "Avaliação da infraestrutura física e recursos disponíveis",
    questions: [
      { texto: "Como você avalia a qualidade das salas de aula?", tipo: "radio", options: ["Excelente", "Bom", "Regular", "Ruim", "Péssimo"], obrigatoria: true },
      { texto: "Os laboratórios atendem às necessidades do curso?", tipo: "radio", options: ["Sim, plenamente", "Sim, parcialmente", "Não", "Não se aplica"], obrigatoria: true },
      { texto: "A biblioteca possui acervo adequado?", tipo: "radio", options: ["Muito adequado", "Adequado", "Pouco adequado", "Inadequado"], obrigatoria: true },
      { texto: "Os equipamentos tecnológicos são adequados?", tipo: "radio", options: ["Sim", "Parcialmente", "Não"], obrigatoria: false },
      { texto: "Há necessidade de melhorias específicas?", tipo: "text", obrigatoria: false }
    ]
  },
  {
    nome: "Autoavaliação do Aluno",
    descricao: "Template para autoavaliação do desempenho e comprometimento do estudante",
    questions: [
      { texto: "Qual foi seu nível de comprometimento com a disciplina?", tipo: "radio", options: ["Muito alto", "Alto", "Médio", "Baixo", "Muito baixo"], obrigatoria: true },
      { texto: "Você participou ativamente das aulas?", tipo: "radio", options: ["Sempre", "Frequentemente", "Às vezes", "Raramente", "Nunca"], obrigatoria: true },
      { texto: "Dedicou tempo adequado aos estudos extraclasse?", tipo: "radio", options: ["Sim", "Parcialmente", "Não"], obrigatoria: true },
      { texto: "Buscou auxílio quando teve dificuldades?", tipo: "radio", options: ["Sempre", "Às vezes", "Raramente", "Nunca"], obrigatoria: false },
      { texto: "O que você pode melhorar no próximo semestre?", tipo: "text", obrigatoria: false }
    ]
  },
  {
    nome: "Coordenação de Curso",
    descricao: "Avaliação da coordenação e gestão do curso",
    questions: [
      { texto: "A coordenação é acessível aos alunos?", tipo: "radio", options: ["Sempre", "Frequentemente", "Às vezes", "Raramente", "Nunca"], obrigatoria: true },
      { texto: "As informações sobre o curso são claras?", tipo: "radio", options: ["Concordo totalmente", "Concordo", "Neutro", "Discordo", "Discordo totalmente"], obrigatoria: true },
      { texto: "Os problemas são resolvidos adequadamente?", tipo: "radio", options: ["Sempre", "Geralmente", "Às vezes", "Raramente", "Nunca"], obrigatoria: true },
      { texto: "A grade curricular atende às expectativas?", tipo: "radio", options: ["Sim, plenamente", "Sim, parcialmente", "Não"], obrigatoria: false },
      { texto: "Sugestões para a coordenação:", tipo: "text", obrigatoria: false }
    ]
  }
]

puts "\n📋 Criando templates..."
templates_data.each do |template_data|
  template = Template.find_or_initialize_by(nome: template_data[:nome])
  
  if template.new_record?
    template.descricao = template_data[:descricao]
    template.save!
    
    template_data[:questions].each do |q|
      template.questions.create!(
        texto: q[:texto],
        tipo: q[:tipo],
        options: q[:options]
      )
    end
    
    puts "  ✓ Template '#{template.nome}' criado com #{template.questions.count} perguntas"
  else
    puts "  - Template '#{template.nome}' já existe"
  end
end

puts "\n✅ Seeds concluídos!"
puts "Total: #{Template.count} templates, #{Question.count} perguntas"
