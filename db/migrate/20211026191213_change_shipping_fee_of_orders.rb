class ChangeShippingFeeOfOrders < ActiveRecord::Migration[5.2]
  def up
    change_column :orders, :shipping_fee, :integer, default: 800
  end
  
  def down
    change_column :orders, :shipping_fee, :integer
  end
end
