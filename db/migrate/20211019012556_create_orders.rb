class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|

      t.integer :customer_id
      t.string :shipping_name
      t.string :shipping_postcode
      t.string :shipping_address
      t.integer :shipping_fee
      t.integer :payment_method
      t.integer :order_status

      t.timestamps


    end
  end
end
