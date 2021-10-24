class Admin::CustomersController < ApplicationController
    
  def index
    @customer = Customer.all
  end
    
end
