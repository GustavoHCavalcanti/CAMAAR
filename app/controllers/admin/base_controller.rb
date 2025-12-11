class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_admin

  def require_admin
    redirect_to root_path unless current_user&.administrador?
  end
end