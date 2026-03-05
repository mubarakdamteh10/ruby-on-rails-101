ActiveRecord::Schema[7.2].define(version: 1) do
  enable_extension "pgcrypto"

  create_table "employees", id: false, primary_key: "employee_id", force: :cascade do |t|
    t.uuid "employee_id", default: -> { "gen_random_uuid()" }, null: false, primary_key: true
    t.string "name", null: false
    t.string "code", null: false
    t.string "department", null: false
    t.string "position", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.timestamps
  end
end