# frozen_string_literal: true

require "csv"
require "securerandom"

class TurmaImportService
  Result = Struct.new(
    :success?,
    :message,
    :created_turmas,
    :created_users,
    :existing_users,
    :errors,
    keyword_init: true
  )

  HEADER_ALIASES = {
    "turma_codigo" => "codigo",
    "codigo_turma" => "codigo",
    "turma" => "codigo",
    "turma_departamento" => "departamento",
    "departamento_turma" => "departamento",
    "turma_semestre" => "semestre",
    "turma_professor" => "professor",
    "aluno_nome" => "nome",
    "nome_aluno" => "nome",
    "aluno_email" => "email",
    "email_aluno" => "email",
    "aluno_matricula" => "matricula",
    "matricula_aluno" => "matricula",
    "senha" => "senha"
  }.freeze

  REQUIRED_FIELDS = %w[codigo departamento nome email matricula].freeze

  def initialize(file:)
    @file = file
  end

  def call
    return failure("Arquivo não enviado.") if @file.nil?

    csv_text = @file.read
    return failure("Arquivo CSV vazio.") if csv_text.strip.empty?

    col_sep = csv_text.include?(";") ? ";" : ","
    table = CSV.parse(csv_text, headers: true, col_sep: col_sep)
    return failure("Arquivo CSV sem linhas de dados.") if table.empty?

    created_turmas = 0
    created_users = 0
    existing_users = 0
    errors = []
    turma_cache = {}

    table.each_with_index do |row, idx|
      data = normalize_row(row)
      missing = REQUIRED_FIELDS.select { |field| data[field].blank? }
      if missing.any?
        errors << "Linha #{idx + 2}: campos obrigatórios ausentes: #{missing.join(', ')}"
        next
      end

      turma = turma_cache[data["codigo"]] ||= Turma.find_or_initialize_by(codigo: data["codigo"])
      if turma.new_record?
        turma.departamento = data["departamento"]
        turma.semestre = data["semestre"]
        turma.professor = data["professor"]
        unless turma.save
          errors << "Linha #{idx + 2}: turma #{data['codigo']} - #{turma.errors.full_messages.to_sentence}"
          turma_cache.delete(data["codigo"])
          next
        end
        created_turmas += 1
      else
        # Atualiza informações básicas se vierem no CSV
        turma.update(
          departamento: data["departamento"] || turma.departamento,
          semestre: data["semestre"] || turma.semestre,
          professor: data["professor"] || turma.professor
        )
      end

      user = User.find_or_initialize_by(matricula: data["matricula"])
      if user.new_record?
        user.nome = data["nome"]
        user.email = data["email"]
        user.role = "participante"
        password = data["senha"].presence || data["matricula"].presence || SecureRandom.alphanumeric(10)
        user.password = password
        user.password_confirmation = password
        unless user.save
          errors << "Linha #{idx + 2}: usuário #{data['matricula']} - #{user.errors.full_messages.to_sentence}"
          next
        end
        created_users += 1
      else
        user.nome ||= data["nome"]
        user.email ||= data["email"]
        user.role ||= "participante"
        unless user.save
          errors << "Linha #{idx + 2}: usuário #{data['matricula']} - #{user.errors.full_messages.to_sentence}"
          next
        end
        existing_users += 1
      end

      turma.turma_users.find_or_create_by(user: user)
    end

    message = "Importação concluída"
    if errors.any?
      message += " com alertas: #{errors.first(3).join(' | ')}"
      success_partial(created_turmas, created_users, existing_users, errors, message)
    else
      success_full(created_turmas, created_users, existing_users, message)
    end
  rescue CSV::MalformedCSVError => e
    failure("CSV inválido: #{e.message}")
  end

  private

  def normalize_row(row)
    normalized = {
      "codigo" => nil,
      "departamento" => nil,
      "semestre" => nil,
      "professor" => nil,
      "nome" => nil,
      "email" => nil,
      "matricula" => nil,
      "senha" => nil
    }

    row.to_h.each do |key, value|
      next if key.nil?

      unified_key = HEADER_ALIASES[key.strip.downcase] || key.strip.downcase
      next unless normalized.key?(unified_key)

      normalized[unified_key] = value.to_s.strip.presence
    end

    normalized
  end

  def failure(message)
    Result.new(
      success?: false,
      message: message,
      created_turmas: 0,
      created_users: 0,
      existing_users: 0,
      errors: []
    )
  end

  def success_full(created_turmas, created_users, existing_users, message)
    Result.new(
      success?: true,
      message: message,
      created_turmas: created_turmas,
      created_users: created_users,
      existing_users: existing_users,
      errors: []
    )
  end

  def success_partial(created_turmas, created_users, existing_users, errors, message)
    Result.new(
      success?: true,
      message: message,
      created_turmas: created_turmas,
      created_users: created_users,
      existing_users: existing_users,
      errors: errors
    )
  end
end
