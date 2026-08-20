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

    table = parse_table(@file.read)
    return failure("Arquivo CSV vazio.") if table.nil?
    return failure("Arquivo CSV sem linhas de dados.") if table.empty?

    created_turmas = 0
    created_users = 0
    existing_users = 0
    errors = []
    turma_cache = {}

    table.each_with_index do |row, idx|
      outcome = process_row(row, idx, turma_cache)
      created_turmas += outcome[:created_turmas]
      created_users += outcome[:created_users]
      existing_users += outcome[:existing_users]
      errors.concat(outcome[:errors]) if outcome[:errors].any?
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

  def parse_table(csv_text)
    return nil if csv_text.to_s.strip.empty?
    col_sep = csv_text.include?(";") ? ";" : ","
    CSV.parse(csv_text, headers: true, col_sep: col_sep)
  rescue CSV::MalformedCSVError
    raise
  end

  def process_row(row, idx, turma_cache)
    data = normalize_row(row)
    missing = missing_required_fields(data)
    return row_error(idx, "campos obrigatórios ausentes: #{missing.join(', ')}") if missing.any?

    errors = []
    created_turmas = 0
    created_users = 0
    existing_users = 0

    turma, created_turma_inc = find_or_create_turma(data, turma_cache, idx, errors)
    return { created_turmas: 0, created_users: 0, existing_users: 0, errors: errors } if turma.nil?
    created_turmas += created_turma_inc

    user_outcome = Users::UpsertFromCsv.new(data: data, idx: idx).call
    errors.concat(user_outcome.errors)
    created_users += user_outcome.created_users
    existing_users += user_outcome.existing_users
    return { created_turmas: created_turmas, created_users: created_users, existing_users: existing_users, errors: errors } if user_outcome.user.nil?

    link_user_to_turma(turma, user_outcome.user)

    { created_turmas: created_turmas, created_users: created_users, existing_users: existing_users, errors: errors }
  end
  def missing_required_fields(data)
    REQUIRED_FIELDS.select { |field| data[field].blank? }
  end

  def row_error(idx, msg)
    { created_turmas: 0, created_users: 0, existing_users: 0, errors: [ "Linha #{idx + 2}: #{msg}" ] }
  end

  def format_errors(record, idx, label)
    "Linha #{idx + 2}: #{label} #{record} - #{yield}"
  end

  def find_or_create_turma(data, turma_cache, idx, errors)
    turma = turma_cache[data["codigo"]] ||= Turma.find_or_initialize_by(codigo: data["codigo"])
    created_inc = 0
    if turma.new_record?
      turma.departamento = data["departamento"]
      turma.semestre = data["semestre"]
      turma.professor = data["professor"]
      unless turma.save
        errors << format_errors(data["codigo"], idx, "turma") { turma.errors.full_messages.to_sentence }
        turma_cache.delete(data["codigo"])
        return nil
      end
      created_inc = 1
    else
      # Atualiza somente se há novos valores
      updates = {}
      updates[:departamento] = data["departamento"] if data["departamento"].present? && data["departamento"] != turma.departamento
      updates[:semestre] = data["semestre"] if data["semestre"].present? && data["semestre"] != turma.semestre
      updates[:professor] = data["professor"] if data["professor"].present? && data["professor"] != turma.professor
      turma.update(updates) if updates.any?
    end
    [ turma, created_inc ]
  end

  # user upsert moved to Users::UpsertFromCsv service

  def link_user_to_turma(turma, user)
    turma.turma_users.find_or_create_by(user: user)
  end

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
