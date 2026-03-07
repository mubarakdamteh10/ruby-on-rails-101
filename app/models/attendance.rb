class Attendance < ApplicationRecord
  self.primary_key = "attendance_id"
  belongs_to :employee, primary_key: :code, foreign_key: :employee_code

  before_save :calculate_metrics

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

  private

  def calculate_metrics
    return unless check_in && check_out

    diff_seconds = (check_out - check_in).to_i
    hours = diff_seconds / 3600
    minutes = (diff_seconds % 3600) / 60

    # Automatically set duration string
    self.duration = "#{hours}h #{minutes}m"

    # Set overtime logic: if duration > 8 hours, overtime is 1 hour
    # Note: 8 hours = 28,800 seconds
    if diff_seconds > 28800
      self.over_time_hour = 1
    else
      self.over_time_hour = 0
    end
  end
end
