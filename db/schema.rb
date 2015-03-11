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

ActiveRecord::Schema.define(version: 20150311182018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "idents", force: :cascade do |t|
    t.string   "ident_code",           limit: 255
    t.string   "name",                 limit: 255
    t.integer  "project_id"
    t.integer  "production_line_id"
    t.string   "production_line_text", limit: 255
    t.datetime "start_expected"
    t.datetime "finish_expected"
    t.datetime "start"
    t.datetime "finish"
    t.float    "weight"
    t.string   "status",               limit: 255
    t.string   "color",                limit: 255
    t.float    "programiranje"
    t.integer  "estimated_hours"
    t.integer  "priority"
  end

  create_table "production_positions", force: :cascade do |t|
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "description",     limit: 255
    t.string   "customer",        limit: 255
    t.datetime "time_start"
    t.datetime "time_end"
    t.string   "production_line", limit: 255
    t.string   "ident",           limit: 255
    t.string   "state",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "color",           limit: 255
  end

end
