class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!
  def show
    @item = Item.find(params[:id])
  end

  def index
    @items = Item.all.page(params[:page]).per(10)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.save
    redirect_to admin_item_path(@item)
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_items_path(@item)
    else
      render "edit"
    end
  end

  private
  def item_params
    params.require(:item).permit(:genre_id, :name, :body, :price, :item_image, :is_active)
  end
end
