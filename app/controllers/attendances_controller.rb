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

  def create
    @employee = Employee.find_by!(code: params[:code])
    @last_attendance = @employee.attendances.order(created_at: :desc).first
    @is_checked_in = @last_attendance.present? && @last_attendance.check_in.present? && @last_attendance.check_out.blank?

    if @is_checked_in
      # Update the existing record for Check Out.
      @last_attendance.update!(check_out: Time.current, timestamp: Time.current)
    else
      # Create a new record for Check In.
      @employee.attendances.create!(check_in: Time.current, timestamp: Time.current)
    end

    redirect_to employee_attendance_path(@employee)
  end
end
