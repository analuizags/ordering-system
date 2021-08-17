class WorkShift < ActiveRecord::Base
  belongs_to :restaurant
  has_many :orders

  validates :name, :restaurant, presence: true

  scope :current_work_shift, ->(current_user_id) { joins(:restaurant).where(restaurants: {user_id: current_user_id}).where(end_at: nil)[0] }

  def close!
    update_attributes({ end_at: Time.current })
  end

  def reopen!
    update_attributes({ end_at: nil })
  end
end
