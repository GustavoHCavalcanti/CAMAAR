# lib/atualizacao_base_sigaa.rb

class SigaaCommunicationError < StandardError; end
class SigaaInconsistentDataError < StandardError; end
class AccessDeniedError < StandardError; end

class BaseAtualizadorSIGAA
  # Estrutura esperada:
  #
  # base_local = {
  #   turmas: [...],
  #   usuarios: [...],
  #   materias: [...],
  # }
  #
  # mock_sigaa_service = objeto com método fetch_data que
  # - retorna dados válidos
  # - lança SigaaCommunicationError se o SIGAA estiver fora
  # - lança SigaaInconsistentDataError se os dados forem inválidos

  def initialize(base_local, sigaa_service)
    @base_local = base_local
    @sigaa_service = sigaa_service
  end

  # admin:
  #   { id: 1, tipo: :admin }
  #   { id: 2, tipo: :comum }
  #
  # Retorna um símbolo indicando o resultado da operação:
  #
  #   :sucesso
  #   :falha_comunicacao
  #   :dados_inconsistentes
  #   :acesso_negado
  #
  def atualizar(admin)
    return :acesso_negado unless admin[:tipo] == :admin

    begin
      novos_dados = @sigaa_service.fetch_data

      validar_dados!(novos_dados)

      substituir_base(novos_dados)
      return :sucesso

    rescue SigaaCommunicationError
      return :falha_comunicacao

    rescue SigaaInconsistentDataError
      return :dados_inconsistentes
    end
  end

  private

  def validar_dados!(dados)
    raise SigaaInconsistentDataError if dados.nil? || !dados.is_a?(Hash)

    # validação mínima: deve ter pelo menos uma chave importante
    required_keys = [:turmas, :usuarios, :materias]
    missing = required_keys.any? { |ch| !dados.key?(ch) }

    raise SigaaInconsistentDataError if missing
  end

  def substituir_base(novos_dados)
    @base_local.clear
    novos_dados.each { |k, v| @base_local[k] = v }
  end
end
