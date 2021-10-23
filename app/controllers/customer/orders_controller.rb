class Customer::OrdersController < ApplicationController

#管理者とログインユーザーのみ閲覧可の記述
	before_action :authenticate!

#退会済みユーザーは閲覧不可の記述
 	before_action :customer_is_deleted

#param[:id]が取得できない場合、閲覧不可
 	before_action :params_check, only: [:index]


# 注文一覧
	def index
		@customer = Customer.find(params[:id])
		@orders = @customer.orders
# 他のユーザーを侵入させないための記述
		unless current_customer.nil? || current_customer.id == @customer.id
      		flash[:warning] = "アクセス権がありません"
			redirect_to orders_path(id: current_customer.id)
		end
	end

# 注文履歴詳細
	def show
	 	@order = Order.find(params[:id])
		unless current_user.nil? || current_user.id == @order.user_id
    		flash[:warning] = "アクセス権がありません"
			redirect_to orders_path(id: current_customer.id)
		end
	end

# 顧客の購入情報の入力画面
	def new
		@customer = current_user
	#cartが空の場合、cart_items#indexに戻される
		if @customer.cart_items.blank?
 		    flash[:warning] = "カートが空です"
			redirect_to cart_items_path
		else
			@order = Order.new(user_id: @customer.id)

		# 	absとは　→ 対象となる数値に対して絶対値を取得することができる。
		# 入れておくと良いらしいがまだよく分かっていない・・・。

			@ads = @customer.shipping_addresses
			@shipping_address = ShippingAddress.new(customer_id: @customer.id)
		end
	end

# 情報の保存

	def create
		@order = Order.new(order_params)
		@customer = current_customer
		@ads = @customer.shipping_addresses
			if params[:_add] == "customersAdd"
				@order.shipping_address = @customer.address
				@order.last_name = @customer.last_name
				@order.first_name = @customer.first_name
				@order.last_name_kana = @customer.last_name_kana
				@order.first_name_kana = @customer.first_name_kana
				@order.ship_postal_code = @customer.postal_code
			elsif params[:_add] == "shipAdds"
				@ad = @ads.find(params[:ShipAddress][:id])
				@order.shipping_address = @ad.address
				@order.last_name = @ad.last_name
				@order.first_name = @ad.first_name
				@order.last_name_kana = @ad.last_name_kana
				@order.first_name_kana = @ad.first_name_kana
				@order.ship_postal_code = @ad.postal_code
			elsif params[:_add] == "newAdd"
			#ship_addressテーブルに保存させる
				@ad = ShippingAddress.new
				@ad.customer_id = @customer.id
				@ad.address = params[:shipping_address][:address]
				@ad.last_name = params[:shipping_address][:last_name]
				@ad.first_name = params[:shipping_address][:first_name]
				@ad.last_name_kana = params[:shipping_address][:last_name_kana]
				@ad.first_name_kana = params[:shipping_address][:first_name_kana]
				@ad.postal_code = params[:shipping_address][:postal_code]
				@ad.phone = params[:shipping_address][:phone]
				@ad.save

				@order.shipping_address = params[:shipping_address][:address]
				@order.last_name = params[:shipping_address][:last_name]
				@order.first_name = params[:shipping_address][:first_name]
				@order.last_name_kana = params[:shipping_address][:last_name_kana]
				@order.first_name_kana = params[:shipping_address][:first_name_kana]
				@order.ship_postal_code = params[:shipping_address][:postal_code]
			end


			#ordered_itemにデータ挿入
			item = []
			@items = @customer.cart_items
				@items.each do |i|
					item << @order.ordered_items.build(product_id: i.product_id, price: i.price, quantity: i.quantity, product_status: 1)
				end
			OrderedItem.import item

		#保存できたかどうかで分岐
		if @order.save
			redirect_to confirm_order_path(@order)
		else
			render :new
		end
	end

#注文情報確認画面
	def confirm
		@order = Order.find(params[:id])
	# 他のuserのアクセス阻止
		unless current_customer.nil? || current_customer.id == @order.customer_id
    		flash[:warning] = "アクセス権がありません"
			redirect_to orders_path(id: current_customer.id)
		end
		@items = @order.ordered_items
	end

# 注文完了画面(カートを空にする)
	def finish
		cart_items = current_customer.cart_items
		cart_items.destroy_all
	end


	private
#ストロングパラメーター
	 def order_params
	 	params.require(:order).permit(
	 		:customer_id, :payment, :shipping_address, :ship_postal_code, :last_name, :first_name, :last_name_kana, :first_name_kana,
	 		shipping_address:[:postal_code, :address, :last_name, :first_name, :last_name_kana, :first_name_kana, :phone]
	 		)
	 end

#退会済みユーザーへの対応
    def customer_is_deleted
      if customer_signed_in? && current_customer.is_deleted?
         redirect_to root_path
      end
    end

#adminでなければcustomerの中で振り分ける
    def authenticate!
      if admin_signed_in?
      else
      	authenticate_customer!
      end
    end

#ordersと直打ちした場合
    def params_check
    	if params[:id].nil?
    		redirect_to root_path
    	end
    end
end