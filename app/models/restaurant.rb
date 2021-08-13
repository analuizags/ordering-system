class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :work_shifts

  validates :name, presence: true

  def activate!
    update_attributes({ active: true })
  end

  def deactivate!
    update_attributes({ active: false })
  end
end
