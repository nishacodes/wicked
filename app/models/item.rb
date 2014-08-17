class Item < ActiveRecord::Base
  attr_accessible :brand, :catID, :category, :container, :description, :ingredients, :manufacturer, :size, :units, :upc, :ProductHasImage, :ProductHasNutritionFacts, :image, :imagethumb
  attr_accessor :nutrition



end
