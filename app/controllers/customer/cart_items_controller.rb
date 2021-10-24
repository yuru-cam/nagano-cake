class Customer::CartItemsController < ApplicationController

  #ログインユーザーのみ見れる、退会者は閲覧不可
  before_action :authenticate_customer!
  before_action :customer_is_deleted

  def index
    @cart_items = current_customer.cart_items
    # カートアイテムの中のidを取り出してプライスのところをitem_
    # @total_price = @cart_items.sum(:price)
    # @total = @cart_items.inject(0) { |sum, item| sum + item.sum_of_price }
  end


  def create
    p @cart_item = CartItem.new(item_params)
    p @cart_item.customer_id = current_customer.id
    # p @cart_item.item_id = params[:item_id]
    #税抜の小計価格を設定
    # @cart_item.price = item_id.price * item_id.quantity
    p @cart_item.save
    redirect_to cart_items_path
  end

  #商品の入ったカートを空にする
  def destroy
    @cart_item = CartItem.find(params[:id])
  	@cart_item.destroy
    redirect_to cart_items_path
  end

  #カートを空にする
  def destroy_all
  	@cart_items = current_customer.cart_items
    @cart_items.destroy_all
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
