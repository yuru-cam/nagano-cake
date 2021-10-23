class ChangeDatatypeItemImageIdOfItems < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :item_image_id, :string
  end
end
