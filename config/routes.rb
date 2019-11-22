Rails.application.routes.draw do
  # get 'categories/show'
  # get 'categories/index'
  resources :categories, only: [:index, :show]
  resources :products, only: [:index, :show]

  collection do
    get 'search_results'
  end

  root to: 'products#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
