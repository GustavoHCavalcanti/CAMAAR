class Respondente::FormulariosController < ApplicationController
  before_action :require_login
  layout "respondente"

  def index
    @formularios = Formulario.all
  end

  def show
    @formulario = ::Formulario.find(params[:id])
    @perguntas = @formulario.template&.questions || []
  end
end
