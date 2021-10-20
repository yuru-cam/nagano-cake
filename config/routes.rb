Rails.application.routes.draw do

# URL /customers/sign_in ...
devise_for :customers, skip: [:passwords], controllers: {
  registrations: "customer/registrations",
  sessions: "customer/sessions"
}

  # 会員用
  scope module: :customer do

    root to: 'homes#top' 
    get '/about' => 'homes#about'

    resources :cart_items, only: [:destroy, :create, :index, :update]

    delete 'cart_items/clear' => 'cart_items#clear'

    resources :items, only: [:index, :show]
    resource :customers, only: [:show, :edit, :update]

    get 'customers/confirm' => 'customers#confirm'
    patch 'customers/withdraw' => 'customers#withdraw'

    resources :orders, only: [:new, :create, :index, :show]

    get 'orders/thanks' => 'orders#thanks'
    post 'orders/confirm' => 'orders#confirm'

    resources :addresses, only: [:create, :index, :destroy, :edit, :update]
  end
  
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords,], controllers: {
  registrations: "customer/registrations",
  sessions: 'customer/sessions'
}
    




# 管理者用

namespace :admin do
  resources :items, only: [:new, :create, :index, :show, :edit, :update]
  resources :genres, only: [:index, :new, :create, :edit, :update]
  resources :customers, only: [:index, :show, :edit, :update]
  resources :orders, only: [:show, :update]
  resources :order_details, only: [:update]

  root to: 'homes#top' #orderのindexだよ

end

# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
