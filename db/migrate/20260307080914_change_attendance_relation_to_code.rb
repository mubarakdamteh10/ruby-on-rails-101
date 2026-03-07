class ChangeAttendanceRelationToCode < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :attendances, :employees
    remove_column :attendances, :employee_id, :uuid
    add_column :attendances, :employee_code, :string, null: false
    add_index :attendances, :employee_code
  end
end
