module ApplicationHelper
  def current_restaurant
    current_user.restaurant
  end

  def has_open_work_shift?
    WorkShift.current_work_shift(current_restaurant.id).blank?
  end
end
