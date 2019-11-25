class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @categories = Category.order(:name)
    @sort = Category.find(params[:id]).Products.sort_by { |p| p.item}
    @sorted = Kaminari.paginate_array(@sort).page(params[:page]).per(9)
  end

  def index
    @categories = Category.order(:name)
  end
end
