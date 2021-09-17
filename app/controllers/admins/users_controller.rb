class Admins::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :authenticate_admin!

  def edit
  end

  def update
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    if password.blank? && password_confirmation.blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to restaurants_path, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
