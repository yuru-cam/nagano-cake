class Customer::CartItemsController < ApplicationController
    def create
        @cart_items = CartItem.all
        @cart_item = CartItem.new(cart_item_params)
        if @cart_item.save
            redirect_to cart_items_path
        end
        
    end
    
    def index
        @customer = Customer.find(params[:id])
        @items = Item.all
        
    end 
    
    def update
        
    end
    
    def destroy
        if @cart_item.destroy
        end    
    end
    
    def clear
        
    end
end
