class CreateShippingAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_addresses do |t|
      t.integer :customer_id
      t.string :shipping_name
      t.string :shipping_postcode
      t.string :shipping_address

      t.timestamps
    end
  end
end
