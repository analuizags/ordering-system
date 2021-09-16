class Order < ActiveRecord::Base
  belongs_to :work_shift
  has_many :order_products
  has_many :products, through: :order_products

  # TODO: colocar condições do proc em um método
  accepts_nested_attributes_for :order_products, allow_destroy: true, reject_if: proc { |obj| OrderProduct.find_by_id(obj[:id].to_i).nil? && obj[:quantity].to_i == 0 }

  validates :table, :status, :work_shift, presence: true
  validates :order_products, length: { minimum: 1, too_short: "mínimo %{count} item" }

  default_scope { order(created_at: :asc, updated_at: :asc) }
  scope :to_the, ->(work_shift_id) { where(work_shift_id: work_shift_id) }
  scope :registered, -> { where(status: 'registered') }
  scope :closed, -> { where(status: 'closed') }
  scope :canceled, -> { where(status: 'canceled') }
  scope :kitchen, -> { joins(:products)
                       .joins("INNER JOIN categories ON products.category_id = categories.id")
                       .where(categories: {see_in_kitchen: true}).uniq }
  scope :for_make, -> { joins(:order_products)
                        .where("(order_products.quantity - order_products.making - order_products.done) != 0").uniq }
  scope :making, -> { joins(:order_products)
                      .where("order_products.making != 0").uniq }
  scope :done, -> { joins(:order_products)
                      .where("order_products.done != 0").uniq }


  def reopen!
    update_attributes({ status: 'registered' })
  end

  def close!
    update_attributes({ status: 'closed' })
  end

  def cancel!
    update_attributes({ status: 'canceled' })
  end
end
