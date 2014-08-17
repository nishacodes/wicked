class Item < ActiveRecord::Base
  attr_accessible :brand, :catID, :category, :container, :description, :ingredients, :manufacturer, :size, :units, :upc, :ProductHasImage, :ProductHasNutritionFacts, :image, :imagethumb
  attr_accessor :nutrition

  def self.find_longest_common_substring(s1, s2)
    if (s1 == "" || s2 == "")
      return ""
    end
    m = Array.new(s1.length){ [0] * s2.length }
    longest_length, longest_end_pos = 0,0
    (0 .. s1.length - 1).each do |x|
      (0 .. s2.length - 1).each do |y|
        if s1[x] == s2[y]
          m[x][y] = 1
          if (x > 0 && y > 0)
            m[x][y] += m[x-1][y-1]
          end
          if m[x][y] > longest_length
            longest_length = m[x][y]
            longest_end_pos = x
          end
        end
      end
    end
    return longest_length
  end

end
