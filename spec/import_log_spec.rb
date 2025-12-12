require "rails_helper"

RSpec.describe ImportLog, type: :model do
  it "é válido com descricao e status" do
    log = ImportLog.new(descricao: "Processado", status: :sucesso)
    expect(log).to be_valid
  end

  it "é inválido sem descricao" do
    log = ImportLog.new(status: :falha)
    expect(log).not_to be_valid
  end
end