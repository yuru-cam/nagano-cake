class ShippingAddress < ApplicationRecord
  belongs_to :customer
  
  validates :shipping_postcode, length: {is: 7}, presence: true
  validates :shipping_address, presence: true
  validates :shipping_name, presence: true
  
  def full_address
    '〒' + shipping_postcode + ' ' + shipping_address + ' ' + shipping_name
  end

end
