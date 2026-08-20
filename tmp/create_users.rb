# Criando usuário aluno
aluno = User.create!(
  nome: 'Aluno Teste',
  email: 'aluno@teste.com',
  matricula: '123456',
  password: '123456',
  password_confirmation: '123456',
  role: 'participante'
)
puts "✓ Usuário aluno criado!"
puts "  Login: aluno@teste.com | Senha: 123456"
puts ""

# Criando usuário admin
admin = User.create!(
  nome: 'Admin Teste',
  email: 'admin@teste.com',
  matricula: 'admin123',
  password: '123456',
  password_confirmation: '123456',
  role: 'administrador'
)
puts "✓ Usuário admin criado!"
puts "  Login: admin@teste.com | Senha: 123456"
