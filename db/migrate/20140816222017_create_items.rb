class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :brand
      t.string :manufacturer
      t.string :category
      t.string :product_has_image
      t.string :container
      t.string :size
      t.string :units
      t.string :upc
      t.string :description
      t.string :ingredients
      t.string :catID

      t.timestamps
    end
  end
end
