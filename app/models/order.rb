class Order < ApplicationRecord

# enamuを利用した支払方法
  enum payment_method: { credit_card: 0, transfer: 1 }
# 注文ステータスの記述
  enum status:  {"入金待ち": 0, "入金確認": 1, "製作中": 2, "発送準備中": 3, "発送済み": 4}

  # enum address_method: {"ご自身の住所": 0, "登録済みの住所から選択": 1, "新しいお届け先": 2}


  belongs_to :customer, optional: true
  has_many :order_details, dependent: :destroy





end
