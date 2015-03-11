class New < ActiveRecord::Migration
  def up
    create_table "idents", force: :cascade do |t|
      t.string   "ident_id",             limit: 255
      t.string   "name",                 limit: 255
      t.string   "project_id",           limit: 255
      t.integer  "production_line_id",   limit: 4
      t.string   "production_line_text", limit: 255
      t.datetime "start_expected"
      t.datetime "finish_expected"
      t.datetime "start"
      t.datetime "finish"
      t.float    "weight",               limit: 24
      t.string   "status",               limit: 255
      t.string   "color",                limit: 255
      t.float    "programiranje",        limit: 24
      t.integer  "estimated_hours",      limit: 4
      t.integer  "priority",             limit: 4
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

  def down
    drop_table :idents
    drop_table :production_positions
    drop_table :projects
  end
end
