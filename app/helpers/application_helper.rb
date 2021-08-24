module ApplicationHelper
  def current_restaurant
    current_user.restaurant
  end

  def has_open_work_shift?
    !current_work_shift.blank?
  end

  def current_work_shift
    WorkShift.current_work_shift(current_restaurant.id)
  end
end
