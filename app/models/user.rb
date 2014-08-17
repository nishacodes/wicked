class User < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :verified

  validates :name, presence: true
  validates :phone, presence: true, uniqueness: true
end
