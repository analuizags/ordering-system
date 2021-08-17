class Admins::SessionsController < Devise::SessionsController
  protected

    def after_sign_in_path_for(resource)
      restaurants_path
    end
end