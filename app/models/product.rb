class Product < ActiveRecord::Base
  belongs_to :category

  monetize :price_cents
end
