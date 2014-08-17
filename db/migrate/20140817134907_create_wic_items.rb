class CreateWicItems < ActiveRecord::Migration
  def change
    create_table :wic_items do |t|
      t.string :upc
      t.string :state
      t.string :category
    end
  end
end


