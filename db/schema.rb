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

ActiveRecord::Schema[8.1].define(version: 2026_03_07_130822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendances", primary_key: "attendance_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.datetime "created_at", null: false
    t.string "duration"
    t.string "employee_code", null: false
    t.integer "over_time_hour"
    t.datetime "timestamp"
    t.datetime "updated_at", null: false
    t.index ["employee_code"], name: "index_attendances_on_employee_code"
  end

  create_table "employees", primary_key: "employee_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.string "department", null: false
    t.string "email", null: false
    t.boolean "is_tax", default: true
    t.string "name", null: false
    t.string "phone", null: false
    t.string "position", null: false
    t.decimal "salary", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["code"], name: "index_employees_on_code", unique: true
  end

  create_table "payrolls", force: :cascade do |t|
    t.decimal "base_salary", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.string "employee_code"
    t.decimal "gross_salary", precision: 10, scale: 2
    t.integer "month"
    t.decimal "net_amount", precision: 10, scale: 2
    t.decimal "ot_payment", precision: 10, scale: 2
    t.decimal "tax_amount", precision: 10, scale: 2
    t.decimal "tax_percentage", precision: 5, scale: 2
    t.decimal "total_ot_hours", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.integer "year"
  end
end
