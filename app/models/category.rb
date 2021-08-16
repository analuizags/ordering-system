class Category < ActiveRecord::Base
  has_many :products

  validates :name, presence: true

  scope :active, -> { where(active: true) }
  scope :deactivate, -> { where(active: false) }

  def activate!
    update_attributes({ active: true })
  end

  def deactivate!
    update_attributes({ active: false })
  end
end
