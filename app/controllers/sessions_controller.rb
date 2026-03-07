class SessionsController < ApplicationController
  def index
    @employees = Employee.all
  end

  def create
    if params[:role] == "admin"
      session[:role] = "admin"
      session[:employee_code] = nil
      redirect_to admin_root_path, notice: "Signed in as Admin"
    elsif params[:employee_code].present?
      session[:role] = "employee"
      session[:employee_code] = params[:employee_code]
      redirect_to employee_attendance_path(params[:employee_code]), notice: "Signed in as #{params[:employee_name]}"
    else
      redirect_to sign_in_option_path, alert: "Invalid login option"
    end
  end

  def destroy
    session[:role] = nil
    session[:employee_code] = nil
    redirect_to sign_in_option_path, notice: "Switching user...", status: :see_other
  end
end
