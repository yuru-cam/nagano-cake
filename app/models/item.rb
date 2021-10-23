class Item < ApplicationRecord
    has_many :genres
    belongs_to :cart_item
    belongs_to :order_detail
    
    attachment :item_image
    validates :name, {presence: true}
    validates :body, {presence: true}
    validates :price, {presence: true}
end
