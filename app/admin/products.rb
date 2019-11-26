ActiveAdmin.register Product do
    permit_params :item, :description, :price, :stock, :percentDiscount, :image, category_products_attributes: [:id, :Product_id, :Category_id, :_destroy]

    form do |f|
      f.semantic_errors *f.object.errors.keys
      f.inputs
      f.inputs do
        f.input :image, as: :file
        f.has_many :category_products, allow_destroy: true do |n_f|
          n_f.input :Category
        end
      end
      f.actions
    end
end
