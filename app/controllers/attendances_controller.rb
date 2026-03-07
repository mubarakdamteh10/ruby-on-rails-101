class AttendancesController < ApplicationController
  before_action :ensure_access!, only: [ :show, :check_in, :check_out ]
  before_action :ensure_admin!, only: [ :index ]

  def index
    @employees = Employee.all.order(:name)
  end

  def show
    @employee = Employee.find_by!(code: params[:code])

    # Get the latest attendance record for today
    @today_attendance = @employee.attendances.where("created_at >= ?", Time.current.beginning_of_day).order(created_at: :desc).first

    # Check current status for today
    @can_check_in = @today_attendance.nil?
    @is_checked_in = @today_attendance.present? && @today_attendance.check_in.present? && @today_attendance.check_out.blank?
    @is_completed_today = @today_attendance.present? && @today_attendance.check_out.present?

    @last_attendance = @is_checked_in ? @today_attendance : @employee.attendances.order(created_at: :desc).first

    # Let's also fetch the history for display.
    @attendances = @employee.attendances.order(created_at: :desc).limit(10)
  end

  def check_in
    @employee = Employee.find_by!(code: params[:code])

    # Guard: Check if already checked in or completed today
    today_attendance = @employee.attendances.where("created_at >= ?", Time.current.beginning_of_day).first
    if today_attendance.present?
      notice = today_attendance.check_out.present? ? "You've already completed attendance for today." : "You're already checked in."
      redirect_path = admin? ? admin_employee_attendance_path(@employee) : employee_attendance_path(@employee)
      return redirect_to redirect_path, alert: notice
    end

    @employee.attendances.create!(check_in: Time.current, timestamp: Time.current)

    redirect_path = admin? ? admin_employee_attendance_path(@employee) : employee_attendance_path(@employee)
    redirect_to redirect_path, notice: "Checked in successfully."
  end

  def check_out
    @employee = Employee.find_by!(code: params[:code])
    @last_attendance = @employee.attendances.where("created_at >= ?", Time.current.beginning_of_day).order(created_at: :desc).first

    if @last_attendance.present? && @last_attendance.check_out.blank?
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
