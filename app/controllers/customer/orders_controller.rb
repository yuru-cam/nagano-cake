class Customer::OrdersController < ApplicationController

  validates :payment, presence: true
  validates :address, presence: true
  
  def new
    @order = Order.new
  # モデルクラスのインスタンス→保存したいテーブルのインスタンスのこと、
  # 今回はordersテーブルに新たにレコードを作成するためこの記述
  # コントローラで作成したインスタンスがnewメソッドで新たに作成されて何も情報を持っていなければ自動的にcreateアクションへ、
  # findメソッドなどで作成され、すでに情報を持っている場合はupdateアクションへ自動的に振り分けてくれる
  
  end

end