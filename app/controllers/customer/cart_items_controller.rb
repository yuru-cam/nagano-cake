class Customer::CartItemsController < ApplicationController

  #ログインユーザーのみ見れる、退会者は閲覧不可
  before_action :authenticate_customer!
  before_action :customer_is_deleted

  def index
    @cart_items = current_customer.cart_items
  end


  def create
    @cart_item = CartItem.new(item_params)
    @cart_items = current_customer.cart_items.all
    @cart_item.customer_id = current_customer.id
    @cart_items.each do |cart_item|
      if @cart_item.item_id == cart_item.item_id
        new_quantity = cart_item.quantity + @cart_item.quantity
        cart_item.update_attribute(:quantity, new_quantity)
        @cart_item.delete
      end
    end
    @cart_item.save
    redirect_to cart_items_path
  end
  
  #カートを空にする
  def clear
  	@cart_items = current_customer.cart_items
    @cart_items.destroy_all
    redirect_to cart_items_path
  end
  
  # 削除や個数を変更した際、カート商品を再計算する
    def update
        @cart_item = CartItem.find(params[:id])
        @cart_item.update(item_params)
        redirect_to cart_items_path
    end

  #1商品を削除する
  def destroy
    @cart_item = CartItem.find(params[:id])
  	@cart_item.destroy
    redirect_to cart_items_path
  end

  private
    def item_params
      params.require(:cart_item).permit(:customer_id, :genre_id, :quantity, :item_id)
    end

    #退会済みユーザーへの対応
    def customer_is_deleted
      if customer_signed_in? && current_customer.is_deleted?
         redirect_to root_path
      end
    end
end
