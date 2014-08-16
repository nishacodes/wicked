class CreateKnownItems < ActiveRecord::Migration
 def change
  create_table :known_items do |t|
    t.string :upc
    t.float :wic_score
    t.string :wic_notes
    t.text :allergens
    t.text :positives
    t.string :size
  end
 end
end
