class Category < ActiveRecord::Base
  has_many :products

  validates :name, presence: true

  scope :to_the, ->(restaurant_id) { where(restaurant_id: restaurant_id) }
  scope :active, -> { where(active: true) }
  scope :deactivate, -> { where(active: false) }
  scope :see_in_kitchen, -> { where(see_in_kitchen: true) }

  def activate!
    update_attributes({ active: true })
  end

  def deactivate!
    update_attributes({ active: false })
  end

  def seeing_in_kitchen!(value)
    update_attributes({ see_in_kitchen: value })
  end
end
