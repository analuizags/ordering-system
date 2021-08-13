class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def new
    build_resource({})
    resource.build_restaurant
    respond_with self.resource
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