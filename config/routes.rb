Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find_all', to: 'merchants#find_all'
      get 'items/find', to: 'items#find'
      resources :merchants, only: %i[index show]
      resources :items, only: %i[index show create]
      put 'items/:id', to: "items#update"
      get 'merchants/:id/items', to: 'merchant_items#index'
      get 'items/:id/merchant', to: 'items_merchant#show'
      get 'revenue/items', to: 'items#revenue'

    end
  end
end
