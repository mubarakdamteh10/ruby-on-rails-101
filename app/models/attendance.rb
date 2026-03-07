class Attendance < ApplicationRecord
  self.primary_key = "attendance_id"
  belongs_to :employee, primary_key: :code, foreign_key: :employee_code

  def self.calculate_duration(check_in, check_out)
    return nil unless check_in && check_out

    diff_seconds = (check_out - check_in).to_i
    hours = diff_seconds / 3600
    minutes = (diff_seconds % 3600) / 60

    "#{hours}h #{minutes}m"
  end

  def formatted_duration
    duration.presence || "-"
  end
end
