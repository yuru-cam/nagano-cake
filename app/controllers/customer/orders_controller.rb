class Customer::OrdersController < ApplicationController

  before_action :authenticate_customer!
  def thanks
  end

  def show
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(order_id: params[:id])
    @cart_items = current_customer.cart_items
    @sum = 0
  end

  def index
    # ログイン中の顧客の情報を取得
    @orders = current_customer.orders
    @sum = 0
  end

  def new
    @customer = current_customer
    @order_address = current_customer.address
    @order = Order.new
  end

  def confirm
    @order = Order.new
    @order.payment_method = params[:order][:payment_method].to_i
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @sum = 0
    # 住所選択の分岐
      # 自分の住所
    if params[:order][:shipping_address_option] == "0"
      @order.shipping_postcode = current_customer.postcode
      @order.shipping_address = current_customer.address
      @order.shipping_name = current_customer.last_name + current_customer.first_name
      #セレクトボックスからの選択 
    elsif params[:order][:shipping_address_option] == "1"
      shipping_address = ShippingAddress.find(params[:order][:dear_address])
      @order.shipping_postcode = shipping_address.shipping_postcode
      @order.shipping_address = shipping_address.shipping_address
      @order.shipping_name = shipping_address.shipping_name
      #新規登録 
    elsif params[:order][:shipping_address_option] == "2"
      @shipping_address = ShippingAddress.new
      @shipping_address.shipping_name = params[:order][:name]
      @shipping_address.shipping_postcode = params[:order][:postcode]
      @shipping_address.shipping_address = params[:order][:address]
      @shipping_address.customer_id = current_customer.id
      @shipping_address.save
      @order.shipping_postcode = params[:order][:postcode]
      @order.shipping_address = params[:order][:address]
      @order.shipping_name = params[:order][:name]
      @order.customer_id = current_customer.id
    end
  end

  def create
      @order = Order.new(order_params)
      @order.customer_id = current_customer.id
      @CartItems = current_customer.cart_items
      @order.order_status = 0
      
      if  @order.save
        #注文受けた　→ 注文詳細テーブルに情報を入れている作業(order_detail)
        #制作ステータスに０を入れる作業が必要
        # item(配列の宣言をしている) = []item << @order.注文詳細モデルs.new(order_id: @order.id)
        current_customer.cart_items.each do |cart_item|
          # item << @order.注文詳細モデルs.new(order_id: @order.id)
          @order_detail = OrderDetail.new
          @order_detail.order_id = @order.id  #注文商品に注文idを紐付け
          @order_detail.item_id = cart_item.item_id
          @order_detail.quantity = cart_item.quantity
          @order_detail.price = cart_item.item.with_tax_price
          @order_detail.making_status = 0
          @order_detail.save
        end
        current_customer.cart_items.destroy_all
        redirect_to orders_thanks_path
      else
        flash[:alert] = "お届け先が正しく入力されていません。お届け先の入力をお願いします。"
        redirect_to  new_orders_path
      end
  end
    
    

    private
    def order_params
      params.require(:order).permit(:customer_id, :shipping_postcode, :shipping_address, :shipping_name, :quantity, :shipping_fee, :payment_method, :order_status )
    end

end