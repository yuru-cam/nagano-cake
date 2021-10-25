class Customer::OrdersController < ApplicationController

# #管理者とログインユーザーのみ閲覧可の記述
# 	before_action :authenticate!

# #退会済みユーザーは閲覧不可の記述
# 	before_action :customer_is_deleted

# #param[:id]が取得できない場合、閲覧不可
# 	before_action :params_check, only: [:index]


# 注文一覧
	def index
		@customer = Customer.find(params[:id])
	end

# 注文履歴詳細
	def show
	 	@order = Order.find(params[:id])
		@order_details = @order.order_details
	end

# 顧客の購入情報の入力画面
	def new
		# @shiping_addresses = current_customer.shipping_addresses
    @shipping_address = ShippingAddress.new
    @order = Order.new
	end

#情報入力画面でボタンを押して情報をsessionに保存
  def create
    if
      params[:order][:select_address] == "0"
      @order.shipping_address = current_customer.address
      @order.shipping_name = current_customer.name
      @order.shipping_postcode = current_customer.postcode
      redirect_to orders_confirm_path
    elsif 
      params[:order][:select]== "1"
       @order.shipping_address = params[:]
      "〒" + current_customer.postcode + current_customer.address + current_customer.last_name + current_customer.first_name
      redirect_to orders_confirm_path
    end
    
    # if session[:address].present? && session[:payment].present?
    #   redirect_to orders_confirm_path
    # else
    #   flash[:order_new] = "支払い方法と配送先を選択して下さい"
    #   redirect_to new_order_path
    # end

  end
  # 購入確認画面
  def confirm
    @order = Order.new(order_params)
  end


  
  # def confirm
  #     @orders = current_customer.orders
  #     @total_price = calculate(current_customer)
  #     if  session[:address].length <8
  #       @address = ShipAddress.find(session[:address])
  #     end
  # end

  # 情報入力画面にて新規配送先の登録
  def create_ship_address
    @ship_address = ShipAddress.new(ship_address_params)
    @ship_address.customer_id = current_customer.id
    @ship_address.save
    redirect_to new_order_path
  end


  def create_order
    # オーダーの保存
    @order = Order.new
    @order.customer_id = current_customer.id
    @order.address = session[:address]
    @order.payment = session[:payment]
    @order.total_price = calculate(current_customer)
    @order.order_status = 0
    @order.save
    # saveができた段階でOrderモデルにorder_idが入る

    # オーダー商品ごとの詳細の保存
    current_customer.cart_items.each do |cart|
      @order_detail = OrderDetail.new
      @order_detail.order_id = @order.id
      @order_detail.item_name = cart.item.name
      @order_detail.item_price = cart.item.price
      @order_detail.quantity = cart.quantity
      @order_detail.item_status = 0
      @order_detail.save

    end
    current_customer.cart_items.destroy_all
    session.delete(:address)
    session.delete(:payment)
    redirect_to thanks_path
  end

  # private
  # def shippping_address_params
  #   params.require(:shippping_address).permit(:customer_id,:last_name, :first_name, :post_code, :address)
  # end
  private
    def order_params
      params.require(:order).permit(:payment_method, :shipping_postcode, :shipping_address, :shipping_name)
    end

end