ActiveAdmin.register Product do
    permit_params :item, :description, :price, :stock, :percentDiscount, :image

    form do |f|
      f.semantic_errors
      f.inputs
      f.inputs do
        f.input :image, as: :file
      end
      f.actions
    end
end
