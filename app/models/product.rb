class Product < ActiveRecord::Base
  belongs_to :category
  has_many :order_products
  has_many :orders, through: :order_products

  monetize :price_cents

  before_save :name_humanize

  validates :name, :category, presence: true
  validates :price_cents, numericality: { greater_than: 0 }

  scope :to_the, ->(restaurant_id) { where(restaurant_id: restaurant_id) }
  scope :active, -> { joins(:category).where(active: true).where(categories: { active: true }) }
  scope :deactivate, -> { joins(:category).where("products.active IS FALSE OR categories.active IS FALSE" ) }
  scope :default_order, -> { joins(:category).order("categories.name, products.name") }

  def name_humanize
    self.name = self.name.humanize.titleize
  end

  def activate!
    update_attributes({ active: true })
  end

  def deactivate!
    update_attributes({ active: false })
  end
end
