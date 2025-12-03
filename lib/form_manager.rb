class FormManager
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

    resultado = resultado.select { |f| f[:turma] == turma } if turma

    if status
      filtro_status = status.to_s.strip.downcase

      resultado = resultado.select do |f|
        form_status = f[:status].to_s.strip.downcase
        form_status == filtro_status
      end
    end

    resultado.map do |form|
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

  # -------------------------
  #  Parte 3 — Abertura do relatório
  # -------------------------
  def open_report(form_code)
    form = @forms.find { |f| f[:codigo] == form_code }
    return :not_found unless form
    return :no_responses if form[:respostas].to_i.zero?

    :open_report_config
  end
end
