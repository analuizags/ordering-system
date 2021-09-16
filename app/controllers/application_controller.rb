class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_restaurant
    current_user.try(:restaurant)
  end

  def has_open_work_shift?
    !current_work_shift.blank?
  end

  def current_work_shift
    WorkShift.current_work_shift(current_restaurant.id)
  end
end
