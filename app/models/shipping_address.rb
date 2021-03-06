class ShippingAddress < ApplicationRecord
  belongs_to :customer, optional: true

  validates :shipping_postcode, length: {is: 7}, presence: true
  validates :shipping_address, presence: true
  validates :shipping_name, presence: true

#   def full_address
#     'γ' + postal_code + ' ' + address + ' ' + name
# γend

  def full_address
  	self.shipping_postcode + "γ" + self.shipping_address + "γ" + self.shipping_name
  end

end
