class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :check_permission, only: [:new, :create, :edit, :update]
  after_action :not_sign_in_after_create

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

  protected

    def check_permission
      admin_signed_in? || redirect_to(new_admin_session_path)
    end
  
    def not_sign_in_after_create
      sign_out(:user)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(
          :sign_up,
          keys:[
            :email, :password, :password_confirmation,
            restaurant_attributes: [:name, :owner]
          ]
      )
    end

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      restaurants_path
    end
end
