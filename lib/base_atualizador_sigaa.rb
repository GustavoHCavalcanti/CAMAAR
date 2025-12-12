# lib/atualizacao_base_sigaa.rb

class SigaaCommunicationError < StandardError; end
class SigaaInconsistentDataError < StandardError; end
class AccessDeniedError < StandardError; end

# Serviço de atualização da base local a partir de dados do SIGAA, com validações e tratamento de erros.
class BaseAtualizadorSigaa
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

  # Recebe a base local e o serviço de integração SIGAA.
  # @param base_local [Hash] armazenamento mutável usado como fonte de dados
  # @param sigaa_service [Object] objeto com método fetch_data
  # @return [BaseAtualizadorSigaa]
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
      :sucesso

    rescue SigaaCommunicationError
      :falha_comunicacao

    rescue SigaaInconsistentDataError
      :dados_inconsistentes
    end
  end

  private

  # Valida estrutura mínima dos dados retornados pelo SIGAA.
  # @param dados [Hash] dados retornados pelo serviço externo
  # @return [void]
  # @raise [SigaaInconsistentDataError] quando dados são nulos, não-hash ou faltam chaves essenciais
  def validar_dados!(dados)
    raise SigaaInconsistentDataError if dados.nil? || !dados.is_a?(Hash)

    # validação mínima: deve ter pelo menos uma chave importante
    required_keys = [ :turmas, :usuarios, :materias ]
    missing = required_keys.any? { |ch| !dados.key?(ch) }

    raise SigaaInconsistentDataError if missing
  end

  # Substitui a base local pela nova carga de dados.
  # @param novos_dados [Hash]
  # @return [void]
  # @side_effect Limpa base_local e grava novos valores
  def substituir_base(novos_dados)
    @base_local.clear
    novos_dados.each { |k, v| @base_local[k] = v }
  end
end
