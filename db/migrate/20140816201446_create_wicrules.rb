class CreateWicrules < ActiveRecord::Migration
 def change
    create_table :wicrules do |t|
      t.string :product
      t.string :brand
      t.text :allowed
      t.text :disallowed
      t.text :size
      t.string :units
      t.string :notes
    end
 end
end



