class ShippingAddress < ApplicationRecord
  belongs_to :customer, optional: true

  validates :shipping_postcode, length: {is: 7}, presence: true
  validates :shipping_address, presence: true
  validates :shipping_name, presence: true

#   def full_address
#     '〒' + postal_code + ' ' + address + ' ' + name
# 　end

  def full_address
  	self.shipping_postcode + "　" + self.shipping_address + "　" + self.shipping_name
  end

end
