Rails.application.routes.draw do

  Rails.application.routes.draw do

    get 'inventory/all', to: 'inventory#all'
    get 'inventory/sku/:token', to: 'inventory#find_sku'
    post 'inventory/sku', to: 'inventory#new_sku'

  end

end
