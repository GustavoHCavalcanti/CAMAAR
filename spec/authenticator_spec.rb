# spec/authenticator_spec.rb

require "spec_helper"
require_relative "../lib/authenticator"

RSpec.describe Authenticator do
  subject(:auth) { described_class.new }

  context "login bem-sucedido com e-mail de usuário comum" do
    it "retorna um usuário respondente" do
      user = auth.login(identificador: "usuario@unb.br", senha: "SenhaValida123")

      expect(user.role).to eq :respondente
      expect(user.email).to eq "usuario@unb.br"
    end
  end

  context "login bem-sucedido com matrícula de usuário comum" do
    it "retorna um usuário respondente" do
      user = auth.login(identificador: "202300000", senha: "SenhaValida123")

      expect(user.role).to eq :respondente
      expect(user.matricula).to eq "202300000"
    end
  end

  context "login bem-sucedido de administrador" do
    it "retorna um admin" do
      user = auth.login(identificador: "admin@unb.br", senha: "SenhaAdmin123")

      expect(user.role).to eq :admin
      expect(user.email).to eq "admin@unb.br"
    end
  end

  context "login com credenciais inválidas" do
    it "lança erro de credenciais inválidas" do
      expect {
        auth.login(identificador: "usuario@unb.br", senha: "senhaErrada")
      }.to raise_error(Authenticator::InvalidCredentials)
    end
  end
end
