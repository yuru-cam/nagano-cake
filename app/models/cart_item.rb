class CartItem < ApplicationRecord
    belong_to :customer
    belong_to :item
end
