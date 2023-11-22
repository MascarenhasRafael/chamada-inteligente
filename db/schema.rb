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

ActiveRecord::Schema[7.0].define(version: 2023_11_22_051840) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accesses", force: :cascade do |t|
    t.string "user_email"
    t.string "user_token"
    t.string "auth_type"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "class_attendances", force: :cascade do |t|
    t.string "professor_id", null: false
    t.string "professor_latitude", null: false
    t.string "professor_longitude", null: false
    t.string "classroom_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "scheduled_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "presences", force: :cascade do |t|
    t.string "student_id", null: false
    t.string "latitude", null: false
    t.string "longitude", null: false
    t.bigint "class_attendance_id", null: false
    t.datetime "approved_at"
    t.datetime "declined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_attendance_id"], name: "index_presences_on_class_attendance_id"
  end

  add_foreign_key "presences", "class_attendances"
end
