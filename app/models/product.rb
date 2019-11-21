class Product < ApplicationRecord

  has_many :category_products
  has_many :Categories, through: :category_products

  validates :item, :description, :price, :stock, presence: true
  validates :stock, numericality: {only_integer: true}
  validates :stock, :percentDiscount, numericality: true

  has_one_attached :image
end
