module Admin
  class TurmasController < ApplicationController
    def index
      @turmas = ::Turma.all
    end

    def show
      @turma = ::Turma.find(params[:id])
    end

    def new
      @turma = ::Turma.new
    end

    def create
      @turma = ::Turma.new(turma_params)
      if @turma.save
        redirect_to admin_turmas_path, notice: "Turma criada com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @turma = ::Turma.find(params[:id])
    end

    def update
      @turma = ::Turma.find(params[:id])
      if @turma.update(turma_params)
        redirect_to admin_turmas_path, notice: "Turma atualizada!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @turma = ::Turma.find(params[:id])
      @turma.destroy
      redirect_to admin_turmas_path, notice: "Turma removida."
    end

    private

    def turma_params
      params.require(:turma).permit(:codigo, :departamento, :semestre)
    end
  end
end
