class Admin::CustomersController < ApplicationController
    
  def index
    @customer = Customer.all
  end
  
  def show
    @customer = Customer.find(params[:id])
  end
    
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def updated
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to admin_customer_path(@customer.id)
  end
  
  
  private
  def customer_params
    params.require(:customer).permit(:full_name, :full_name_kana, :postcode, :address, :phone_number, :email, :is_deleted)
  end
end
