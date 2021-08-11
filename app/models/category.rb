class Category < ActiveRecord::Base
  has_many :products

  validates :name, presence: true

  def activate!
    update_attributes({ active: true })
  end

  def deactivate!
    update_attributes({ active: false })
  end
end
