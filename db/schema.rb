# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140817005130) do

  create_table "items", :force => true do |t|
    t.string   "brand"
    t.string   "manufacturer"
    t.string   "category"
    t.string   "ProductHasImage"
    t.string   "container"
    t.string   "size"
    t.string   "units"
    t.string   "upc"
    t.string   "description"
    t.string   "ingredients"
    t.string   "catID"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "ProductHasNutritionFacts"
    t.string   "image"
    t.string   "imagethumb"
  end

  create_table "known_items", :force => true do |t|
    t.string "upc"
    t.float  "wic_score"
    t.string "wic_notes"
    t.text   "allergens"
    t.text   "positives"
    t.string "size"
  end

  create_table "messages", :force => true do |t|
    t.string   "body"
    t.string   "from"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "image"
    t.string   "upc"
    t.string   "item_requested"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.boolean  "verified"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "wicrules", :force => true do |t|
    t.string "product"
    t.string "brand"
    t.text   "allowed"
    t.text   "disallowed"
    t.text   "size"
    t.string "units"
    t.string "notes"
  end

end
