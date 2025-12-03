# lib/listar_formularios_relatorio.rb

class FormManager
  # Estrutura esperada para cada formulário:
  # {
  #   id: 1,
  #   codigo: "F-CIC101",
  #   turma: "CIC101",
  #   owner_id: 10,
  #   status: "Fechado" ou "Aberto",
  #   respostas: 10
  # }
  def initialize(forms)
    @forms = forms || []
  end

  # Lista formulários e permite filtro opcional por turma ou status
  def list_for(admin_id, turma: nil, status: nil)
    resultado = @forms

    resultado = resultado.select { |f| f[:turma] == turma }   if turma
    resultado = resultado.select { |f| f[:status] == status } if status

    resultado.map do |form|
      {
        id:        form[:id],
        codigo:    form[:codigo],
        turma:     form[:turma],
        respostas: form[:respostas],
        status:    form[:status],
        can_generate_report: form[:respostas] > 0
      }
    end
  end

  # Acesso à geração de relatório
  # Retorna:
  #   :open_report_config  → OK, pode gerar
  #   :no_responses        → formulário tem 0 respostas
  #   :not_found           → formulário inexistente
  def open_report(form_code)
    form = @forms.find { |f| f[:codigo] == form_code }
    return :not_found unless form

    return :no_responses if form[:respostas].to_i == 0

    :open_report_config
  end
end
