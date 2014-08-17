class Wicrule < ActiveRecord::Base
 attr_accessible :product, :brand, :allowed, :disallowed, :size, :units, :notes


end