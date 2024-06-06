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

ActiveRecord::Schema[7.1].define(version: 2024_05_30_023848) do
  create_table "twinkle_apps", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_twinkle_apps_on_slug", unique: true
  end

  create_table "twinkle_datapoints", force: :cascade do |t|
    t.integer "twinkle_summary_id", null: false
    t.string "name"
    t.string "value"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twinkle_summary_id", "name", "value"], name: "idx_on_twinkle_summary_id_name_value_575cc7ed34", unique: true
    t.index ["twinkle_summary_id"], name: "index_twinkle_datapoints_on_twinkle_summary_id"
  end

  create_table "twinkle_events", force: :cascade do |t|
    t.integer "twinkle_app_id", null: false
    t.string "version"
    t.boolean "cpu64bit"
    t.integer "ncpu"
    t.string "cpu_freq_mhz"
    t.string "cputype"
    t.string "cpusubtype"
    t.string "model"
    t.string "ram_mb"
    t.string "os_version"
    t.string "lang"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twinkle_app_id"], name: "index_twinkle_events_on_twinkle_app_id"
  end

  create_table "twinkle_summaries", force: :cascade do |t|
    t.integer "twinkle_app_id", null: false
    t.integer "period"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["period", "start_date", "end_date"], name: "index_twinkle_summaries_on_period_and_start_date_and_end_date"
    t.index ["twinkle_app_id"], name: "index_twinkle_summaries_on_twinkle_app_id"
  end

  create_table "twinkle_versions", force: :cascade do |t|
    t.integer "twinkle_app_id", null: false
    t.string "number"
    t.string "build"
    t.string "description"
    t.string "binary_url"
    t.string "dsa_signature"
    t.string "ed_signature"
    t.string "length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false, null: false
    t.index ["build"], name: "index_twinkle_versions_on_build"
    t.index ["twinkle_app_id", "published"], name: "index_twinkle_versions_on_twinkle_app_id_and_published"
    t.index ["twinkle_app_id"], name: "index_twinkle_versions_on_twinkle_app_id"
  end

  add_foreign_key "twinkle_datapoints", "twinkle_summaries"
  add_foreign_key "twinkle_events", "twinkle_apps"
  add_foreign_key "twinkle_summaries", "twinkle_apps"
  add_foreign_key "twinkle_versions", "twinkle_apps"
end
