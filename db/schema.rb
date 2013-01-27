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

ActiveRecord::Schema.define(:version => 20130119231317) do

  create_table "bridges", :force => true do |t|
    t.string   "name"
    t.string   "host"
    t.string   "mac_address"
    t.string   "username"
    t.boolean  "registered"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "bridge_id"
    t.boolean  "all_group"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups_lights", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "light_id"
  end

  create_table "lights", :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.boolean  "on"
    t.integer  "brightness"
    t.integer  "hue"
    t.integer  "saturation"
    t.float    "x"
    t.float    "y"
    t.float    "ct"
    t.string   "alert"
    t.string   "effect"
    t.string   "color_mode"
    t.boolean  "reachable"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
