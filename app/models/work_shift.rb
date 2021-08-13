class WorkShift < ActiveRecord::Base
  belongs_to :restaurant
  has_many :orders

  validates :name, :restaurant, presence: true

  def close!
    update_attributes({ end_at: Time.current })
  end

  def reopen!
    update_attributes({ end_at: nil })
  end
end
