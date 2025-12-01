# lib/form_responder.rb

class FormResponder
  # formulario: objeto que representa o formulário
  # usuario: participante que está respondendo
  # respostas: hash com as respostas (ex: { q1: "Muito bom", q2: "Comentário" })
  # perguntas_obrigatorias: lista dos IDs das perguntas obrigatórias (ex: [:q1, :q2])
  def responder(formulario:, usuario:, respostas:, perguntas_obrigatorias:)
    todas_preenchidas = perguntas_obrigatorias.all? do |pergunta_id|
      valor = respostas[pergunta_id]
      !valor.nil? && !valor.to_s.strip.empty?
    end

    unless todas_preenchidas
      # Cenário triste: faltou responder alguma obrigatória
      return :campos_obrigatorios_em_branco
    end

    # Cenário feliz: registra a avaliação
    # Aqui, para o domínio da disciplina, basta marcar que o usuário respondeu
    formulario.respondido_por << usuario unless formulario.respondido_por.include?(usuario)

    :sucesso
  end
end
