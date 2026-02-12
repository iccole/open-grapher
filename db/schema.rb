# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_12_031851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "lookups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "error"
    t.string "image"
    t.string "lookup_id"
    t.string "og_type"
    t.string "og_url"
    t.string "session_id"
    t.string "site_name"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["session_id", "lookup_id"], name: "index_lookups_on_session_id_and_lookup_id", unique: true
    t.index ["session_id"], name: "index_lookups_on_session_id"
  end
end
