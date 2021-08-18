class WorkShift < ActiveRecord::Base
  belongs_to :restaurant
  has_many :orders

  validates :name, :restaurant, presence: true

  scope :to_the, ->(restaurant_id) { where(restaurant_id: restaurant_id) }

  def close!
    update_attributes({ end_at: Time.current })
  end

  def reopen!
    update_attributes({ end_at: nil })
  end

  def self.current_work_shift(restaurant_id)
    to_the(restaurant_id).where(end_at: nil).first
  end
end
