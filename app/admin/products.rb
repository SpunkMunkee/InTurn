ActiveAdmin.register Product do
    permit_params :item, :description, :price, :stock, :percentDiscount
end
