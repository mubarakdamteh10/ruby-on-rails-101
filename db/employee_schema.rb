ActiveRecord::Schema[7.2].define(version: 1) do
  create_table "employees", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.string "employee_id", null: false, index: { unique: true }
    t.timestamps
  end
end