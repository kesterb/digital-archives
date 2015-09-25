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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150925002801) do

  create_table "production_credits_event_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "production_credits_productions", force: :cascade do |t|
    t.string  "production_name"
    t.string  "category"
    t.date    "open_on"
    t.date    "close_on"
    t.integer "work_id"
    t.string  "venue_alias"
  end

  add_index "production_credits_productions", ["work_id"], name: "index_production_credits_productions_on_work_id"

  create_table "production_credits_productions_venues", id: false, force: :cascade do |t|
    t.integer "production_id"
    t.integer "venue_id"
  end

  add_index "production_credits_productions_venues", ["production_id", "venue_id"], name: "index_productions_venues"
  add_index "production_credits_productions_venues", ["venue_id", "production_id"], name: "index_venues_productions"

  create_table "production_credits_venues", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "production_credits_works", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.date     "year_written"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
