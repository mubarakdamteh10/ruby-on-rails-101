class AttendancesController < ApplicationController
  def index
    @employees = Employee.all.order(:name)
  end

  def show
    @employee = Employee.find_by!(code: params[:code])
    @last_attendance = @employee.attendances.order(created_at: :desc).first
    # is_checked_in means the employee has checked in but not checked out yet.
    @is_checked_in = @last_attendance.present? && @last_attendance.check_in.present? && @last_attendance.check_out.blank?

    # Let's also fetch the history for display.
    @attendances = @employee.attendances.order(created_at: :desc).limit(10)
  end

  def check_in
    @employee = Employee.find_by!(code: params[:code])
    @employee.attendances.create!(check_in: Time.current, timestamp: Time.current)

    redirect_to employee_attendance_path(@employee), notice: "Checked in successfully."
  end

  def check_out
    @employee = Employee.find_by!(code: params[:code])
    @last_attendance = @employee.attendances.order(created_at: :desc).first

    if @last_attendance.present? && @last_attendance.check_out.blank?
      check_out_time = Time.current
      duration_string = Attendance.calculate_duration(@last_attendance.check_in, check_out_time)

      @last_attendance.update!(
        check_out: check_out_time,
        timestamp: check_out_time,
        duration: duration_string
      )
      notice = "Checked out successfully."
    else
      notice = "No active check-in found."
    end

    redirect_to employee_attendance_path(@employee), notice: notice
  end
end
