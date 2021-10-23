class Order < ApplicationRecord
  
# enamuを利用した支払方法
  enum payment_method: { credit_card: 0, transfer: 1 }
# 注文ステータスの記述
  enum deposit_status: {入金待ち:1,発送待ち:2,発送済み:3}


# belongs_toでcustomerによってorders所有されていますよというアソシエーション
　belongs_to :customer
  
  
  # has_manyでアソシエーション、dependent :destroyで削除命令可能にする
  has_many :ordered_items, dependent: :destroy
	has_many :products, through: :ordered_items
	accepts_nested_attributes_for :ordered_items
	
	
	  validates :last_name_kana, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい。'}, presence: true
    validates :first_name_kana, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい。'}, presence: true
    validates :ship_postal_code, format: /\A[0-9]+\z/, presence: true#郵便番号数字のみ
    validates :last_name, presence: true
    validates :first_name, presence: true
end
