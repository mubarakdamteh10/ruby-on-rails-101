class AttendancesController < ApplicationController
  before_action :ensure_access!, only: [ :show, :check_in, :check_out ]
  before_action :ensure_admin!, only: [ :index ]

  def index
    @employees = Employee.all.order(:name)
  end

  def show
    @employee = Employee.find_by!(code: params[:code])

    @is_checked_in = @employee.checked_in?
    @is_completed_today = @employee.completed_attendance_today?
    @can_check_in = @employee.can_check_in?

    @open_attendance = @employee.open_attendance
    @today_record = @employee.today_record
    @today_attendance = @open_attendance || @today_record
    @last_attendance = @open_attendance || @employee.attendances.order(check_in: :desc).first

    # History display
    @attendances = @employee.attendances.order(check_in: :desc).limit(10)
  end

  def check_in
    @employee = Employee.find_by!(code: params[:code])
    redirect_path = admin? ? admin_employee_attendance_path(@employee) : employee_attendance_path(@employee)

    # Guard: Cannot check in if already checked in
    if @employee.checked_in?
      return redirect_to redirect_path, alert: "You're already checked in."
    end

    # Guard: Cannot check in if a record already started today
    if @employee.completed_attendance_today? || @employee.today_record.present?
      return redirect_to redirect_path, alert: "You've already completed attendance for today."
    end

    @employee.process_check_in!
    redirect_to redirect_path, notice: "Checked in successfully."
  end

  def check_out
    @employee = Employee.find_by!(code: params[:code])
    redirect_path = admin? ? admin_employee_attendance_path(@employee) : employee_attendance_path(@employee)

    if @employee.process_check_out!
      notice = "Checked out successfully."
    else
      notice = "No active check-in found."
    end

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
