class CartItem < ApplicationRecord

  belongs_to :customer
  belongs_to :item

  def subtotal
    item.with_tax_price * quantity
  end

#   def sum_of_price
#     item_id.price * 1.1 * item_id.quantity
#   end

	validates :quantity, presence: true

end
