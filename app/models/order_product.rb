class OrderProduct < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :quantity, :order_id, :product_id, presence: true

  def make!
    registered = quantity.to_i - done.to_i
    update_attributes({ making: registered })
  end

  def done!
    make = making.to_i + done.to_i
    update_attributes({ making: 0, done: make })
  end
end
