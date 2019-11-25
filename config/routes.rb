Rails.application.routes.draw do
  # get 'categories/show'
  # get 'categories/index'
  resources :categories, only: [:index, :show]

  resources :products, only: :index
  resources :products, only: :show do
    collection do
      get 'search_results', to: ''
    end
  end

  post 'products/add_to_cart/:id', to: 'products#add_to_cart', as: 'add_to_cart'
  post 'products/delete_from_cart/:id', to: 'products#delete_from_cart', as: 'delete_from_cart'
  delete 'products/remove_from_cart/:id', to: 'products#remove_from_cart', as: 'remove_from_cart'
  root to: 'products#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
