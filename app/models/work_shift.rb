class WorkShift < ActiveRecord::Base
  belongs_to :restaurant
  has_many :orders

  validates :name, :restaurant, presence: true

  default_scope { order(end_at: :desc, start_at: :desc) }
  scope :to_the, ->(restaurant_id) { where(restaurant_id: restaurant_id) }

  def close!
    OrderProduct.where(quantity: 0).destroy_all
    update_attributes({ end_at: Time.current })
  end

  def reopen!
    update_attributes({ end_at: nil })
  end

  def self.current_work_shift(restaurant_id)
    to_the(restaurant_id).where(end_at: nil).first
  end
end
