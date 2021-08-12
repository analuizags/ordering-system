class Product < ActiveRecord::Base
  belongs_to :category
  has_many :order_products
  has_many :orders, through: :order_products

  monetize :price_cents

  validates :name, :category, presence: true

  def activate!
    update_attributes({ active: true })
  end

  def deactivate!
    update_attributes({ active: false })
  end
end
