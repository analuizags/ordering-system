class Admins::AdminsController < ApplicationController
  before_action :set_admin, only: [:edit, :update]
  before_action :authenticate_admin!

  def edit
  end

  def update
    password = params[:admin][:password]
    password_confirmation = params[:admin][:password_confirmation]

    if password.blank? && password_confirmation.blank?
      params[:admin].delete(:password)
      params[:admin].delete(:password_confirmation)
    end

    if @admin.update(admin_params)
      redirect_to restaurants_path, notice: "Admin was successfully updated."
    else
      render :edit
    end
  end

  private

    def set_admin
      @admin = Admin.find(params[:id])
    end

    def admin_params
      params.require(:admin).permit(:email, :password, :password_confirmation)
    end
end
