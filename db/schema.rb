# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_11_144803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descricao"
    t.string "publico_alvo"
    t.integer "status", default: 0, null: false
    t.bigint "template_id", null: false
    t.string "titulo", default: "", null: false
    t.bigint "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "import_logs", force: :cascade do |t|
    t.string "arquivo"
    t.datetime "created_at", null: false
    t.text "mensagem"
    t.integer "novos_registros"
    t.integer "registros_existentes"
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "template_id", null: false
    t.string "texto", null: false
    t.string "tipo", default: "texto"
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questions_on_template_id"
  end

  create_table "reset_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expira_em"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["token"], name: "index_reset_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_reset_tokens_on_user_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "formulario_id", null: false
    t.bigint "question_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.text "valor"
    t.index ["formulario_id"], name: "index_respostas_on_formulario_id"
    t.index ["question_id"], name: "index_respostas_on_question_id"
    t.index ["user_id"], name: "index_respostas_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descricao"
    t.string "nome", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "departamento", null: false
    t.string "semestre"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "matricula"
    t.string "nome"
    t.string "password_digest"
    t.string "role", default: "aluno"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
  end

  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "questions", "templates"
  add_foreign_key "reset_tokens", "users"
  add_foreign_key "respostas", "formularios"
  add_foreign_key "respostas", "questions"
  add_foreign_key "respostas", "users"
end
