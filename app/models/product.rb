class Product < ApplicationRecord
  validates :item, :description, :price, :stock, presence: true
  validates :stock, numericality: {only_integer: true}
  validates :stock, :percentDiscount, numericality: true
end
