# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# json = ActiveSupport::JSON.decode(File.read('db/wicrules.json'))
 
# json.each do |a|
#   Wicrule.create!(a['wicrule'], without_protection: true)
# end

rules = JSON.parse(File.read('db/wicrules.json'))
rules.each do |rule|
  Wicrule.create(rule)
end

wicitems = JSON.parse(File.read('db/wicitems.json'))
wicitems.each do |wicitem|
  Wic_item.create(wicitem)
end