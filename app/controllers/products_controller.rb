class ProductsController < ApplicationController
  def index
    @products = Product.order(:item).page(params[:page])
    @categories = Category.order(:name)
  end

  def show
    @product = Product.find(params[:id])
  end

  def search_results; end
end
