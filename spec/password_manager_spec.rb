# spec/password_manager_spec.rb

require "spec_helper"
require_relative "../lib/password_manager"

RSpec.describe PasswordManager do
  subject(:manager) { described_class.new }

  describe "#definir_senha" do
    context "quando o token é válido e a senha atende aos requisitos" do
      it "retorna :sucesso" do
        resultado = manager.definir_senha(
          token_valido: true,
          senha: "NovaSenha123",
          confirmacao: "NovaSenha123"
        )

        expect(resultado).to eq :sucesso
      end
    end

    context "quando o token é inválido ou expirado" do
      it "retorna :token_invalido" do
        resultado = manager.definir_senha(
          token_valido: false,
          senha: "NovaSenha123",
          confirmacao: "NovaSenha123"
        )

        expect(resultado).to eq :token_invalido
      end
    end

    context "quando a confirmação da senha é divergente" do
      it "retorna :confirmacao_divergente" do
        resultado = manager.definir_senha(
          token_valido: true,
          senha: "NovaSenha123",
          confirmacao: "OutraSenha456"
        )

        expect(resultado).to eq :confirmacao_divergente
      end
    end

    context "quando a senha não atende aos requisitos mínimos" do
      it "retorna :senha_fraca" do
        resultado = manager.definir_senha(
          token_valido: true,
          senha: "123",
          confirmacao: "123"
        )

        expect(resultado).to eq :senha_fraca
      end
    end
  end

  describe "#redefinir_senha" do
    it "segue as mesmas regras da definição de senha" do
      resultado = manager.redefinir_senha(
        token_valido: true,
        senha: "SenhaNova123",
        confirmacao: "SenhaNova123"
      )

      expect(resultado).to eq :sucesso
    end
  end
end
