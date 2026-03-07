class Attendance < ApplicationRecord
  self.primary_key = "attendance_id"
  belongs_to :employee
end
