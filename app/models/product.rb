class Product < ActiveRecord::Base
  belongs_to :category
  has_many :order_products
  has_many :orders, through: :order_products

  monetize :price_cents

  validates :name, :category, presence: true
  validates :price_cents, numericality: { greater_than: 0 }

  scope :active, -> { joins(:category).where(active: true).where(categories: { active: true }) }
  scope :deactivate, -> { joins(:category).where("products.active IS FALSE OR categories.active IS FALSE" ) }

  def activate!
    update_attributes({ active: true })
  end

  def deactivate!
    update_attributes({ active: false })
  end
end
