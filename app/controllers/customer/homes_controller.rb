class Customer::HomesController < ApplicationController
  
  def top
    @genres = Genre.all
    @items = Item.all.page(params[:page]).per(4)
  end
  
  def about
  end
  
end
