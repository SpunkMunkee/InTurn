class Product < ApplicationRecord

  has_many :category_products, foreign_key: "Product_id"
  has_many :Categories, through: :category_products

  accepts_nested_attributes_for :category_products, allow_destroy: true

  validates :item, :description, :price, :stock, presence: true
  validates :stock, numericality: {only_integer: true}
  validates :stock, :percentDiscount, numericality: true

  has_one_attached :image
end
