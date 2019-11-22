class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @sort = Category.find(params[:id]).Products.sort_by { |p| p.item}
    @sorted = Kaminari.paginate_array(@sort).page(params[:page]).per(6)
  end

  def index
    @categories = Category.all
  end
end
