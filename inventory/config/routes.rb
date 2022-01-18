Rails.application.routes.draw do

  get 'inventory/all', to: 'inventory#all'
  get 'inventory/sku/:token', to: 'inventory#find_sku'
  post 'inventory/sku', to: 'inventory#new_sku'
  patch 'inventory/sku', to: 'inventory#update_sku'
  delete 'inventory/sku', to: 'inventory#delete_sku'
  post 'inventory/delete', to: 'inventory#delete_sku'
  delete 'inventory/delete', to: 'inventory#undo_delete'
end