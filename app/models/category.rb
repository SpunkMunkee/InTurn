class Category < ApplicationRecord
  has_many :category_products
  has_many :Products, through: :category_products
end