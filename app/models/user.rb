class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :restaurant

  accepts_nested_attributes_for :restaurant, allow_destroy: true

  def active_for_authentication?
    super && self.restaurant.active?
  end
end
