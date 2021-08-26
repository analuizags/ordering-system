class Order < ActiveRecord::Base
  belongs_to :work_shift
  has_many :order_products
  has_many :products, through: :order_products

  # TODO: colocar condições do proc em um método
  accepts_nested_attributes_for :order_products, allow_destroy: true, reject_if: proc { |obj| OrderProduct.find_by_id(obj[:id].to_i).nil? && obj[:quantity].to_i == 0 }

  validates :table, :status, :work_shift, presence: true
  validates :order_products, length: { minimum: 1, too_short: "mínimo %{count} item" }

  scope :to_the, ->(work_shift_id) { where(work_shift_id: work_shift_id) }
  scope :registered, -> { where(status: 'registered') }
  scope :closed, -> { where(status: 'closed') }
  scope :canceled, -> { where(status: 'canceled') }

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
