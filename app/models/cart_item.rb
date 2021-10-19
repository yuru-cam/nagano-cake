class CartItem < ApplicationRecord
    belongs_to :customer
    belongs_to :item
  def sum_of_price
    item.price * quantity
  end
end
