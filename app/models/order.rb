class Order < ApplicationRecord
  
# enamuを利用した支払方法
  enum payment_method: { credit_card: 0, transfer: 1 }
# 注文ステータスの記述
  enum deposit_status: {入金待ち:1,発送待ち:2,発送済み:3}


　belongs_to :customer
  has_many :order_details, dependent: :destroy
	

end
