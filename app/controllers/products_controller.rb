class ProductsController < ApplicationController

  before_action :initialize_session
  before_action :load_cart

  def index
    @products = Product.order(:item).page(params[:page]).per(9)
    @categories = Category.order(:name)
  end

  def show
    @product = Product.find(params[:id])
    @categories = Category.order(:name)
  end

  def search_results
    @query = params[:query]
    @cat   = params[:category]

    if @cat == "ALL"
      @cat_name = "All Products"
      @results = Product.where('item LIKE ?', "%#{@query}%")
    elsif @cat == "SALE"
      @cat_name = "On Sale"
      @results = Product.where("percentDiscount > ?", 0.0)
    elsif @cat == "RU"
      @cat_name = "Recently Updated"
      @results = Product.where("updated_at > ?", DateTime.now.change(hour: 0))
    elsif
      @category = Category.find(@cat)
      @cat_name = @category.name
      @results = @category.Products.where('item LIKE ?', "%#{@query}%")
    end
  end

  def add_to_cart
    id = params[:id]
    count = 1
    if session[:cart][id]
      session[:cart][id]["item_count"] = session[:cart][id]["item_count"] + count
    else
      product = Product.find(id.to_i)
      session[:cart][id] = {"item_count" => count, "item" => product.item}
    end

    redirect_to root_path
  end

  def delete_from_cart
    id = params[:id]
    count = 1
    if session[:cart][id]["item_count"] > 1
      session[:cart][id]["item_count"] = session[:cart][id]["item_count"] - count
    else
      session[:cart].delete(id.to_s)
    end
    redirect_to root_path
  end

  def remove_from_cart
    id = params[:id]
    session[:cart].delete(id.to_s)
    redirect_to root_path
  end

  private

  def initialize_session
    session[:cart] ||= {}
  end

  def load_cart
    @cart = session[:cart]
  end
end
