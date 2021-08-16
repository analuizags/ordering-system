class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :check_permission, only: [:new, :create, :edit, :update]

  def new
    build_resource({})
    resource.build_restaurant
    respond_with self.resource
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def check_permission
    admin_signed_in? || redirect_to(new_admin_session_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
        :sign_up,
        keys:[
          :email, :password, :password_confirmation,
          restaurant_attributes: [:name, :owner]
        ]
    )
  end
end
