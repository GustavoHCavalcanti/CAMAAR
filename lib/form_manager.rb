# Serviço para listar e gerenciar estados de formulários (pendentes, filtros e abertura de relatório).
class FormManager
  # Armazena formulários e oferece utilidades de listagem e pendência.
  # @param forms [Array<Hash>] coleção de formulários
  def initialize(forms = [])
    @forms = forms || []
  end

  # -------------------------
  #  Parte 1 — Formulários pendentes (issue 109)
  # -------------------------
  def formularios_pendentes(user, turmas_ids_usuario, formularios)
    formularios.select do |form|
      turmas_ids_usuario.include?(form.turma_id) &&
        form.pendente_para?(user)
    end
  end

  # -------------------------
  #  Parte 2 — Listagem e filtros (issue 110)
  # -------------------------
  def list_for(_admin_id, turma: nil, status: nil)
    resultado = @forms
    resultado = filtrar_por_turma(resultado, turma) if turma
    resultado = filtrar_por_status(resultado, status) if status
    resultado.map { |form| mapear_form(form) }
  end

  # -------------------------
  #  Parte 3 — Abertura do relatório
  # -------------------------
  def open_report(form_code)
    form = @forms.find { |f| f[:codigo] == form_code }
    return :not_found unless form
    return :no_responses if form[:respostas].to_i.zero?

    :open_report_config
  end

  private

  def filtrar_por_turma(forms, turma)
    forms.select { |f| f[:turma] == turma }
  end

  def filtrar_por_status(forms, status)
    filtro_status = status.to_s.strip.downcase
    forms.select { |f| f[:status].to_s.strip.downcase == filtro_status }
  end

  def mapear_form(form)
    {
      id:        form[:id],
      codigo:    form[:codigo],
      turma:     form[:turma],
      respostas: form[:respostas],
      status:    form[:status],
      can_generate_report: form[:respostas].to_i > 0
    }
  end
end
