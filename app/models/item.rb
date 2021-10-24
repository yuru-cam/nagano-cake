class Item < ApplicationRecord
    belongs_to :genre
    has_many :cart_items
    has_many :order_details
    
    attachment :item_image
    validates :name, {presence: true}
    validates :body, {presence: true}
    validates :price, {presence: true}
end
