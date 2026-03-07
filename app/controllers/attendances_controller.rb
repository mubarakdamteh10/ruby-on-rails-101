class AttendancesController < ApplicationController
  before_action :ensure_access!, only: [ :show, :check_in, :check_out ]
  before_action :ensure_admin!, only: [ :index ]

  def index
    @employees = Employee.all.order(:name)
  end

  def show
    @employee = Employee.find_by!(code: params[:code])

    # 1. Look for any open record (missing a check_out) - Priority for "Check Out" button
    @open_attendance = @employee.attendances.where(check_out: nil).order(check_in: :desc).first

    # 2. Look for the record that STARTED today
    @today_record = @employee.attendances.where(check_in: Date.current.all_day).first

    # 3. Logic Flags
    @is_checked_in = @open_attendance.present?

    # Completed Today: If a record started today AND it is already closed
    @is_completed_today = @today_record.present? && @today_record.check_out.present?

    # Can Check In: Only if no record is currently open AND no record started today
    @can_check_in = !@is_checked_in && @today_record.nil?

    # For display consistency
    @today_attendance = @open_attendance || @today_record
    @last_attendance = @open_attendance || @employee.attendances.order(check_in: :desc).first

    # History display
    @attendances = @employee.attendances.order(check_in: :desc).limit(10)
  end

  def check_in
    @employee = Employee.find_by!(code: params[:code])

    # Guard: Cannot check in if already checked in (open record exists)
    if @employee.attendances.where(check_out: nil).exists?
      notice = "You're already checked in."
      redirect_path = admin? ? admin_employee_attendance_path(@employee) : employee_attendance_path(@employee)
      return redirect_to redirect_path, alert: notice
    end

    # Guard: Cannot check in if a record already started today
    if @employee.attendances.where(check_in: Date.current.all_day).exists?
      notice = "You've already completed attendance for today."
      redirect_path = admin? ? admin_employee_attendance_path(@employee) : employee_attendance_path(@employee)
      return redirect_to redirect_path, alert: notice
    end

    @employee.attendances.create!(check_in: Time.current, timestamp: Time.current)

    redirect_path = admin? ? admin_employee_attendance_path(@employee) : employee_attendance_path(@employee)
    redirect_to redirect_path, notice: "Checked in successfully."
  end

  def check_out
    @employee = Employee.find_by!(code: params[:code])
    # Close the latest open record, regardless of day
    @last_attendance = @employee.attendances.where(check_out: nil).order(check_in: :desc).first

    if @last_attendance.present?
      check_out_time = Time.current

      @last_attendance.update!(
        check_out: check_out_time,
        timestamp: check_out_time
      )
      notice = "Checked out successfully."
    else
      notice = "No active check-in found."
    end

    redirect_path = admin? ? admin_employee_attendance_path(@employee) : employee_attendance_path(@employee)
    redirect_to redirect_path, notice: notice
  end

  private

  def ensure_admin!
    redirect_to sign_in_option_path, alert: "Access denied" unless admin?
  end

  def ensure_access!
    # Admin can see any attendance, Employee only their own
    return if admin?

    if employee? && session[:employee_code] == params[:code]
      return
    end

    redirect_to sign_in_option_path, alert: "Access denied. You can only view your own attendance."
  end
end
