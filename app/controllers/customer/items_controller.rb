class Customer::ItemsController < ApplicationController
  before_action :authenticate_customer! , only: :show
  
  def index
      @items = Item.where(is_active: "true").page(params[:page]).per(6)
  end
  
  def show
      @item = Item.find(params[:id])
      @cart_item = CartItem.new
  end

end
