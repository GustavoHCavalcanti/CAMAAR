# frozen_string_literal: true

module Users
  class UpsertFromCsv
    Outcome = Struct.new(:user, :created_users, :existing_users, :errors, keyword_init: true)

    def initialize(data:, idx:)
      @data = data
      @idx = idx
    end

    def call
      user = ::User.find_or_initialize_by(matricula: @data["matricula"])
      if user.new_record?
        assign_new_user_attributes(user)
        return save_new_user(user)
      else
        assign_existing_user_defaults(user)
        return save_existing_user(user)
      end
    end

    private

    def assign_new_user_attributes(user)
      user.nome = @data["nome"]
      user.email = @data["email"]
      user.role = "participante"
      password = @data["senha"].presence || @data["matricula"].presence || SecureRandom.alphanumeric(10)
      user.password = password
      user.password_confirmation = password
    end

    def assign_existing_user_defaults(user)
      user.nome ||= @data["nome"]
      user.email ||= @data["email"]
      user.role ||= "participante"
    end

    def save_new_user(user)
      if user.save
        Outcome.new(user: user, created_users: 1, existing_users: 0, errors: [])
      else
        Outcome.new(user: nil, created_users: 0, existing_users: 0, errors: [error_msg(user, 'usuário')])
      end
    end

    def save_existing_user(user)
      if user.save
        Outcome.new(user: user, created_users: 0, existing_users: 1, errors: [])
      else
        Outcome.new(user: nil, created_users: 0, existing_users: 0, errors: [error_msg(user, 'usuário')])
      end
    end

    def error_msg(record, label)
      "Linha #{@idx + 2}: #{label} #{@data['matricula']} - #{record.errors.full_messages.to_sentence}"
    end
  end
end
