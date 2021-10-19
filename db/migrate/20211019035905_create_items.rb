class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.integer :genre_id
      t.string :name
      t.text :body
      t.integer :price
      t.integer :item_image_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
