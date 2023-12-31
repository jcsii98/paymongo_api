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

ActiveRecord::Schema[7.0].define(version: 2023_11_26_155113) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "slots", force: :cascade do |t|
    t.jsonb "distance_hash", default: {}, null: false
    t.string "slot_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "vehicle_plate"
    t.string "vehicle_type"
    t.string "entrance"
    t.datetime "time_in"
    t.datetime "time_out"
    t.integer "amount"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "slot_id"
    t.index ["slot_id"], name: "index_tickets_on_slot_id"
  end

  add_foreign_key "tickets", "slots"
end
