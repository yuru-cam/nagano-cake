class Admin::OrdersController < ApplicationController

  before_action :authenticate_admin!

  def index
    if params[:day]
      @orders = Order.created_today
    else
      @orders = Order.all
    end
  end

  def show
  	@order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def update
    #orderのoeder_statusの更新
  	@order = Order.find(params[:id])
    @order.update(order_params)
    flash[:success] = "更新に成功しました"
    if @order.order_status == "入金確認"
			  @order.order_details.update_all(making_status: "製作待ち") end
		redirect_to admin_order_path
  end

  private
  def order_params
  	params.require(:order).permit(:order_status,ordered_details_attributes:[:id, :making_status])
  end
end
