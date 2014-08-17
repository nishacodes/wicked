class RenameColumnsInItems < ActiveRecord::Migration
  def change
    rename_column :items, :product_has_image, :ProductHasImage
    add_column :items, :ProductHasNutritionFacts, :string

  end

end
