class Attendance < ApplicationRecord
  self.primary_key = "attendance_id"
  belongs_to :employee, primary_key: :code, foreign_key: :employee_code
end
