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

ActiveRecord::Schema.define(version: 20150126193826) do

  create_table "credits", force: true do |t|
    t.string  "credit_type"
    t.integer "work_id"
    t.integer "production_id"
    t.integer "performance_id"
    t.integer "role_id"
    t.integer "person_id"
  end

  add_index "credits", ["performance_id"], name: "index_credits_on_performance_id"
  add_index "credits", ["person_id"], name: "index_credits_on_person_id"
  add_index "credits", ["production_id"], name: "index_credits_on_production_id"
  add_index "credits", ["role_id"], name: "index_credits_on_role_id"
  add_index "credits", ["work_id"], name: "index_credits_on_work_id"

  create_table "names", force: true do |t|
    t.string   "full_name"
    t.integer  "person_id"
    t.integer  "venue_id"
    t.datetime "cannonized_at"
  end

  add_index "names", ["person_id"], name: "index_names_on_person_id"
  add_index "names", ["venue_id"], name: "index_names_on_venue_id"

  create_table "people", force: true do |t|
    t.string "denormalized_full_name"
    t.string "disambiguation"
    t.date   "date_of_birth"
  end

  create_table "performances", force: true do |t|
    t.integer  "production_id"
    t.datetime "performed_at"
  end

  add_index "performances", ["production_id"], name: "index_performances_on_production_id"

  create_table "production_credits_productions", force: true do |t|
    t.string  "production_name"
    t.string  "category"
    t.date    "open_on"
    t.date    "close_on"
    t.integer "work_id"
    t.integer "venue_id"
    t.string  "venue_alias"
  end

  add_index "production_credits_productions", ["venue_id"], name: "index_production_credits_productions_on_venue_id"
  add_index "production_credits_productions", ["work_id"], name: "index_production_credits_productions_on_work_id"

  create_table "production_credits_venues", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "production_credits_works", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.date     "year_written"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "productions", force: true do |t|
    t.integer "work_id"
    t.date    "open_on"
    t.date    "close_on"
  end

  add_index "productions", ["work_id"], name: "index_productions_on_work_id"

  create_table "roles", force: true do |t|
    t.string  "category"
    t.string  "name"
    t.integer "work_id"
    t.integer "production_id"
  end

  add_index "roles", ["production_id"], name: "index_roles_on_production_id"
  add_index "roles", ["work_id"], name: "index_roles_on_work_id"

  create_table "venues", force: true do |t|
    t.string "denormalized_name"
    t.date   "opened_on"
  end

  create_table "works", force: true do |t|
    t.string  "title"
    t.string  "medium"
    t.integer "year"
  end

end
