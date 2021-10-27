class Customer::HomesController < ApplicationController
  
  def top
    @genres = Genre.all
    @items = Item.where(is_active: "true").page(params[:page]).per(3)
  end
  
  def about
  end
  
end
