class Order < ActiveRecord::Base
  belongs_to :work_shift
  has_many :order_products
  has_many :products, through: :order_products

  accepts_nested_attributes_for :products, reject_if: :all_blank, allow_destroy: true
end
